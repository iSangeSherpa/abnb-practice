//
//  ForgotPasswordViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/12/2022.
//

import Foundation
import RxSwift
import RxRelay

class ForgotPasswordViewModel : ViewModel{
    
    let userRepository = UserRepositoryImpl()
    
    let email = BehaviorRelay<String>(value : "")
    let password = BehaviorRelay<String>(value : "")
    let retypePassword = BehaviorRelay<String>(value : "")
    
    let onPasswordResetToken = PublishRelay<Void>()
    
    func passwordResetToken(){
        if(validationSuccess()){
            userRepository
                .passwordResetToken(email: email.value)
                .observe(on: MainScheduler.instance)
                .do(
                    onSubscribe: { [weak self] in
                        self?.loading.accept(true)
                    },
                    onDispose: { [weak self] in
                        self?.loading.accept(false)
                    }
                ).subscribe(
                    onSuccess: { [weak self] _ in
                        self?.onPasswordResetToken.accept(Void())
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
        }
    }
    
    func validationSuccess() -> Bool {
        if email.value == "" {
            self.alert("Email cannot be empty.")
            return false
        }
        if email.value.isEmailValid == false {
            self.alert("Email is not valid.")
            return false
        }
      
        return true
    }
}
