//
//  ResetPasswordViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 24/02/2023.
//

import Foundation
import RxRelay
import RxSwift

class ResetPasswordViewModel : ViewModel{
 
    
    let userRepository = UserRepositoryImpl()
    
    let otpCode = BehaviorRelay<String>(value : "")
    let email = BehaviorRelay<String>(value : "")
    let password = BehaviorRelay<String>(value : "")
    let retypePassword = BehaviorRelay<String>(value : "")
    let onPasswordResetSuccess = PublishRelay<Void>()
    
    func validationSuccess() -> Bool {
        if email.value == "" {
            self.alert("Email cannot be empty.")
            return false
        }
        if email.value.isEmailValid == false {
            self.alert("Email is not valid.")
            return false
        }
        
        if password.value == "" {
            self.alert("New Password cannot be empty.")
            return false
        }
        
        if password.value.isPasswordValid == false {
            self.alert("New Password is not valid.")
            return false
        }
        
        if retypePassword.value == "" {
            self.alert("Retype Password cannot be empty.")
            return false
        }
        
        if retypePassword.value.isPasswordValid == false {
            self.alert("Retyped password is not valid.")
            return false
        }
        
        if password.value != retypePassword.value {
            self.alert("New Password does not match Retyped New password.")
            return false
        }
        return true
    }
    
    func resetPassword(){
        if(!validationSuccess()){
            return
        }
        
        userRepository
            .resetPassword(password: self.password.value, email: self.email.value, token: self.otpCode.value)
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
                    self?.onPasswordResetSuccess.accept(Void())
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
                
    }
}
