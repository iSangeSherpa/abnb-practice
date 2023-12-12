//
//  LoginScrenViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 14/09/2022.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

enum LoginStatus{
    case Success
    case IncompleteProfile
    case Unverified
}
class LoginScreenViewModel : ViewModel {
    let userRepository = UserRepositoryImpl()
    
    let email  = BehaviorRelay(value: "")
    let password  = BehaviorRelay(value: "")
    
    let loginAction = PublishRelay<LoginStatus>()
    
    func login(){
        if(!validationSuccess()){
            return
        }
        SessionManager.shared.saveEmail(email: email.value)
        userRepository.login(email: email.value.lowercased(), password: password.value)
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
                    SessionManager.shared.saveSession(
                        accessToken: $0.data.accessToken.token,
                        userId: $0.data.userId,
                        sessionId: $0.data.id,
                        refreshToken: $0.data.refreshToken
                    )
                    self?.getUserDetails()
                },
                onFailure: { error in
                    if let error = error as? Failure{
                        switch(error){
                        case .ServerError(message: _, status: let statusCode):
                            if(statusCode == "airbark_20013"){
                                self.loginAction.accept(.Unverified)
                                return
                            }
                        default:
                            print()
                        }
                        self.error.accept(error)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    func getUserDetails(){
        userRepository.getUserDetails()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { [weak self] it in
                    if (it.completionStatus != .COMPLETED) {
                        self?.loginAction.accept(.IncompleteProfile)
                        return
                    }
                    if (it.activeProfile == .MINDER){
                        if(it.minderProfile?.completionStatus != .COMPLETED){
                            self?.loginAction.accept(.IncompleteProfile)
                            return
                        }
                    }
                    if(it.activeProfile == .FINDER){
                        if(it.finderProfile?.completionStatus != .COMPLETED){
                            self?.loginAction.accept(.IncompleteProfile)
                            return
                        }
                    }
                    SessionManager.shared.userType = it.activeProfile
                    SessionManager.shared.user = it
                    SessionManager.shared.finderAvailableStatus = it.finderProfile?.availableStatus
                    SessionManager.shared.availableStatus = it.minderProfile?.availableStatus
                    self?.loginAction.accept(.Success)
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func validationSuccess()->Bool{
        if(!email.value.isEmailValid){
            self.alert(.Register.invalidEmail)
            return false
        }
        else if (!password.value.isPasswordValid){
            self.alert(.Register.invalidPassword)
            return false
        }
        return true
    }
}
