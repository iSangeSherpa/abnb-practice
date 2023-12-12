//
//  RegisterScreenViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 22/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class RegisterScreenViewModel : ViewModel{
    let userRepository  = UserRepositoryImpl()
    
    let email  = BehaviorRelay(value: "")
    let password  = BehaviorRelay(value: "")
    let confirmPassword  = BehaviorRelay(value: "")
    let acceptTerms = BehaviorRelay<Bool>(value: false)
    
    let registrationAction = PublishRelay<Bool>()
    
    func createUser(){
        if(validationSuccess()){
            userRepository
                .createUser(email: email.value.lowercased(), password: password.value)
                .observe(on: MainScheduler.instance)
                .do(
                    onSubscribe: { [weak self] in
                        self?.loading.accept(true)
                    },
                    onDispose: { [weak self] in
                        self?.loading.accept(false)
                    }
                ).subscribe(
                    onSuccess: { [weak self] in
                        SessionManager.shared.saveEmail(email: $0.email)
                        self?.registrationAction.accept(true)
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
        }
    }
    
    func validationSuccess() -> Bool{
        if(!email.value.isEmailValid){
            self.alerts.accept(.error(.Register.invalidEmail))
            return false
        }
        else if(!password.value.isPasswordValid){
            self.alerts.accept(.error(.Register.invalidPassword))
            return false
        }
        else if(password.value != confirmPassword.value){
            self.alerts.accept(.error(.Register.passwordsNotMatched))
            return false
        }
        else if(!acceptTerms.value){
            self.alerts.accept(.error(.Register.termsConditionsNotAccepted))
            return false
        }
        
        return true
    }
    
}
