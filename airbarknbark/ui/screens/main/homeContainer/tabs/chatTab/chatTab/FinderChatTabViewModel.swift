//
//  HomeTabViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxRelay
import RxSwift
import RxRealm
import RealmSwift

class FinderChatTabViewModel : ViewModel{
    let conversationRepository = ConversationRepositoryImp()
    
    let conversationItems = BehaviorRelay<[ConversationWithLatestMessage]>(value: [])
       
    required init() {
        super.init()
        self.refreshConversation()
        
        conversationRepository.getAllConversationWithLastMessageFlow()
            .bind(onNext: conversationItems.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func refreshConversation(){
        conversationRepository.refreshConversations()
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(onError: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func deleteConversation(conversationId : String){
        conversationRepository.deleteConversation(conversationId: conversationId)
            .delay(.seconds(2),scheduler : MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onCompleted: {
                    print("test")
                },
                onError: self.error.accept(_:)
            )
            .disposed(by: disposeBag)
        
    }
}

