//
//  ChangePasswordViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class ChangePasswordViewModel : ViewModel {
    
    var currentPassword = BehaviorRelay<String>(value : "")
    var newPassword = BehaviorRelay<String>(value : "")
    var retypePassword = BehaviorRelay<String>(value : "")
    
    
    func changePassword() {
        if isValid() {
            self.callingChangePasswordApi()
        }
    }
    
    func isValid() -> Bool {
        if currentPassword.value == "" {
            self.alert("Current Password cannot be empty.")
            return false
        }
        
        if currentPassword.value.isPasswordValid == false {
            self.alert("Current Password is not valid.")
            return false
        }
        
        if newPassword.value == "" {
            self.alert("New Password cannot be empty.")
            return false
        }
        
        if newPassword.value.isPasswordValid == false {
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
        
        if newPassword.value != retypePassword.value {
            self.alert("New Password does not match Retyped New password.")
            return false
        }
        return true
    }
    
    func callingChangePasswordApi() {
        UserRepositoryImpl()
            .updatePassword(password: newPassword.value,
                            currentPassword: currentPassword.value)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(onSuccess: { [weak self] userDetails in
            guard let self = self else {return}
                
            self.currentPassword.accept("")
            self.newPassword.accept("")
            self.retypePassword.accept("")
            self.alerts.accept(.success("Changed password successfully."))
                
        }, onFailure: { [weak self] err in
            self?.error.accept(err)
        }, onDisposed: nil).disposed(by: disposeBag)
    }
}

