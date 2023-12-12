//
//  ChatDetailsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation
import RxRelay
import RxSwift
import RealmSwift
import RxRealm

class ChatDetailsViewModel : ViewModel {
    var conversationId = ""
    
    let homeRepository = HomeRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
   
    let conversationRepository = ConversationRepositoryImp()
    
    let chatMessageItems =  BehaviorRelay<[MessageWithOtherUser]>(value: [])
    let conversation  = BehaviorRelay<Conversation?>.init(value: nil)
    let onNewMessageReceived  = PublishRelay<Void>()
    let message = BehaviorRelay<String>(value: "")
    
    
   

    func getChatMessages(){
     
        conversationRepository.getMessagesForConversationFlow(conversationId: conversationId).debounce(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext:{
                self.chatMessageItems.accept($0)
                self.onNewMessageReceived.accept(Void())
            })
            .disposed(by: disposeBag)
        
        conversationRepository.getConversationFlow(conversationId: conversationId)
            .bind(onNext: {
                self.conversation.accept(Conversation(id: $0.id, updatedAt: $0.updatedAt, users: $0.users.toArray()))
            })
            .disposed(by: disposeBag)
        
        refresh()
    }
    
    
    func updateSeenStatus(){
        if(!chatMessageItems.value.isEmpty){
            conversationRepository.setSeenStatus(conversationId: conversationId).asObservable().debounce(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.asyncInstance).bind{_ in
            }.disposed(by: disposeBag)
        }
    }
    
    func refresh(){
        conversationRepository.refreshMessagesForConversation(conversationId: conversationId)
            .subscribe(onError: error.accept(_:))
            .disposed(by: disposeBag)
        
        conversationRepository.refreshConversations()
            .do( onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            })
            .subscribe(onError: error.accept(_:))
            .disposed(by: disposeBag)
       
        
    }
    
    func sendNewMessage(){
        let messageValue = message.value
        conversationRepository.sendNewMessage(conversationId: conversationId, text: messageValue)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onCompleted: { [weak self] in
                    self?.message.accept("")
                },
                onError: {  [weak self] in
                    self?.message.accept(messageValue)
                    self?.error.accept($0)
                }
            )
            .disposed(by: disposeBag)
        
    }
    
    func sendNewMedia(media : UIImage){
        self.utilRepository.uploadFile(fileData: (media.jpeg(.high))!,fileName: "media.jpeg",type: .OTHER)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).flatMapCompletable{ [self] in
                self.conversationRepository.sendNewMessage(conversationId: conversationId,media: [$0.path])
            }
            .subscribe(onError: error.accept)
            .disposed(by: disposeBag)
        
    }
    
}
