//
//  CoonversationsRepository.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 12/12/2022.
//

import Foundation
import RxRelay
import RxSwift
import RealmSwift

protocol  ConversationRepository{
    func getAllConversationWithLastMessageFlow() -> Observable<[ConversationWithLatestMessage]>
    func refreshConversations() -> Completable
    func refreshMessagesForConversation(conversationId:String) -> Completable
    func setSeenStatus(conversationId:String) -> Completable
    func getMessagesForConversationFlow(conversationId:String) -> Observable<[MessageWithOtherUser]>
    func getConversationFlow(conversationId:String) -> Observable<Conversation>
    func sendNewMessage(conversationId:String, text:String?, media:[String]) -> Completable
    func handleSocketNewMessageEvent(data:[Any])
}

class ConversationRepositoryImp : ConversationRepository{
  
    
    private let realm = try! Realm()


    func getAllConversationWithLastMessageFlow() -> Observable<[ConversationWithLatestMessage]> {
        
        let messagesFilter = realm.objects(ConversationMessage.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .distinct(by: ["conversationID"])
        
        let conversationFilter = realm.objects(Conversation.self)
        
        return Observable.combineLatest(
            Observable.array(from: conversationFilter),
            Observable.array(from: messagesFilter)
        ){ conversations, messages in
//            if((conversations.map{$0.isInvalidated}.isEmpty || messages.map{$0.isInvalidated}.isEmpty)){
//                return []
//            }
           
            let conversationsWithLastMessage = conversations
                .map{ conversation in
                 ConversationWithLatestMessage(
                    conversation: conversation,
                    lastMessage: messages.first(where: { messsage in
                        messsage.conversationID == conversation.id
                    })
                 )
                }
                .sorted(by: { a, b in
                    let aDate = a.lastMessage?.createdAt.asDateTime() ?? a.conversation.updatedAt.asDateTime()
                    let bDate = b.lastMessage?.createdAt.asDateTime() ?? b.conversation.updatedAt.asDateTime()
                    return aDate.compare(bDate) == .orderedDescending
                })
            
            
            SessionManager.shared.chatBadgeCount = conversationsWithLastMessage.filter{!($0.lastMessage?.isSeen ?? true)}.count
            
            return conversationsWithLastMessage
        }
    }

    func refreshConversations() -> Completable {
       return ApiService.getAllConversations(userId: SessionManager.shared.userId!)
            .do(onSuccess: { [self] result in
            
                let cachedConversation = realm.objects(Conversation.self)

                try! realm.write { [self] in
                    self.realm.delete(cachedConversation)
                }
                
               let conversations =  result.data.map { it in
                    it.toDomain()
               }.filter{$0.users.count>1}
                
                let messages = result.data.flatMap {
                    $0.messages.map{
                        $0.toDomain()
                    }
                }
               
               try! realm.write { [self] in
                   self.realm.add(conversations, update: .all)
                   self.realm.add(messages, update: .all)
                }
            }).asCompletable()
    }
    
    func refreshMessagesForConversation(conversationId:String) -> Completable {
        return ApiService.getMessagesForConversation(userId: SessionManager.shared.userId!, conversationId: conversationId)
            .do(onSuccess: { [self] result in
                let messages =  result.data.map { it in
                    it.toDomain()
                }
                
                try! realm.write { [self] in
                    self.realm.add(messages, update: .modified)
                }
            }).asCompletable()
    }
    
    func setSeenStatus(conversationId : String) -> Completable{
        return ApiService.updateSeenStatus(userId: SessionManager.shared.userId!, conversationId: conversationId)
            .do(onSuccess: { [self] result in
                let message =  result.data.toDomain()
                try! realm.write { [self] in
                    self.realm.add(message, update: .modified)
                }
            }).asCompletable()
    }
    
    func getMessagesForConversationFlow(conversationId:String) -> Observable<[MessageWithOtherUser]> {
        
        return Observable.array(from: realm.objects(ConversationMessage.self)
            .filter("conversationID == %@", conversationId))
            .map { [self] messages in
                let conversation  = self.realm.object(ofType: Conversation.self, forPrimaryKey: conversationId)
                if(conversation?.isInvalidated ?? true){
                    return []
                }
                return messages
                    .sorted(by: { a, b in
                        a.createdAt.asDateTime().compare(b.createdAt.asDateTime()) == .orderedAscending
                    })
                    .map{ message in
                        
                    MessageWithOtherUser(
                        message: message,
                        otherUser: conversation!.otherUser
                    )
                }
            }
    }
    
    func getConversationFlow(conversationId:String) -> Observable<Conversation>{
       
        return Observable.create{ observer in
            Observable.from(object: self.realm.object(ofType: Conversation.self, forPrimaryKey: conversationId)!).subscribe(onNext:{ conversation in
                observer.onNext(conversation)
            })
        }
    }
    
    func startConversation(receiverId : String) ->Single<String>{
        let userId = SessionManager.shared.userId!
        
        return Single<String>.create { observer in
            
            ApiService.startConversation(userId: userId , param: ["users":[userId,receiverId]])
                     .subscribe(onSuccess: { [self] result in
                           
                         let messages = result.data.messages.map {
                             $0.toDomain()
                         }
                          
                         try! realm.write { [self] in
                             self.realm.add(result.data.toDomain(), update: .modified)
                             self.realm.add(messages, update: .modified)
                          }
                         
                         observer(.success(result.data.id))
                     }, onFailure : {
                         observer(.failure($0))
                     })
           }
    
    }
    
    func sendNewMessage(conversationId:String, text:String? = nil, media:[String] = []) -> Completable{
        let userId = SessionManager.shared.userId ?? ""
        let params = text == nil ?  [ "media" : media ] : [ "text": text!]
        
        return ApiService.sendNewMessage(userId: userId, conversationId: conversationId, param: params)
            .map{
                $0.data.toDomain()
            }
            .do(onSuccess: { [self] message in
                try! self.realm.write {
                    self.realm.add(message.apply { it in
                        !it.seenByUserIds.contains(SessionManager.shared.userId ?? "") ? it.seenByUserIds.append(SessionManager.shared.user?.id ?? "" ) : ()
                    }, update: .modified)
                }
            })
            .asCompletable()
    }
    
    func deleteConversation(conversationId : String) -> Completable{
        let cachedConversation = realm.objects(Conversation.self).filter{$0.id == conversationId}

        try! realm.write { [self] in
            self.realm.delete(cachedConversation)
        }
        return Completable.empty()
    }
    
    
    func handleSocketNewMessageEvent(data:[Any]){
        do {
            let json = try! JSONSerialization.data(withJSONObject: data)
            let messagesList = try! Config.jsonDecoder.decode([ConversationMessageModel].self, from: json)
                .map{
                    $0.toDomain()
                }
            
            try realm.write {
                realm.add(messagesList,update: .modified)
            }
        } catch {
            print(error)
        }
    }
}
