//
//  BlockedUsersViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/02/2023.
//

import Foundation
import RxRelay
import RxSwift

class BlockedUsersViewModel : ViewModel{
    let userRepository = UserRepositoryImpl()
    let blockedUsersList =  BehaviorRelay<[BlockedUserDetails]>(value: [])
    
    required init() {
        super.init()
        self.getBlockedUsers()
    }
    
    func getBlockedUsers(){
        self.userRepository.getBlockedUsers()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                    
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
                .subscribe(
                    onSuccess: { blockedUsersList in
                        self.blockedUsersList.accept(blockedUsersList.map{$0.blockedUser})
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
    }
    
    func unblockUser(userId: String){
        self.userRepository.unblockUser(toUserId: userId )
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                    
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
                .subscribe(
                    onSuccess: { blockedUsersList in
                        self.getBlockedUsers()
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
    }
}
