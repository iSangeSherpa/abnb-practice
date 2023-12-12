//
//  VerifyResetTokenViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/12/2022.
//

import Foundation
import RxRelay
import RxSwift

class VerifyPasswordResetViewModel : ViewModel{
    
    var email = ""
    let userRepository = UserRepositoryImpl()
    
    let codeSentText = BehaviorRelay<String>(value: "")
    let showResendCode = BehaviorRelay<Bool>(value: true)
    
    let otpFields  = [
        BehaviorRelay(value: ""),
        BehaviorRelay(value: ""),
        BehaviorRelay(value: ""),
        BehaviorRelay(value: ""),
        BehaviorRelay(value: ""),
        BehaviorRelay(value: "")
    ]
    
    let verifyAction = PublishRelay<Bool>()
    
    
    required init() {
        super.init()
        self.startResendCodeTimer()
    }
    
    func resendPasswordResetToken(){
        userRepository
            .passwordResetToken(email: self.email)
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
                    self?.startResendCodeTimer()
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
                }
    
    
    func getOtpCode()->String{
        var otpCode = ""
        for otpField in otpFields {
            otpCode += otpField.value
        }
        return otpCode
    }
    
    func resetPassword(){
        if(!validationSuccess(code:getOtpCode())){
            return
        }
        
        userRepository
            .checkPasswordResetToken(email: email, token: getOtpCode())
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
                    self?.verifyAction.accept(true)
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
        
                }
    
    func validationSuccess(code:String)->Bool{
        if(code.count != otpFields.count){
            self.alert(.VerifyOTP.invalidOTP)
            return false
        }
        return true
    }
    
    func startResendCodeTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showResendCode.accept(false)
        }
        
        Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .take(Config.OTP_VERIFICATION_COUNTDOWN_TIMER + 1)
            .subscribe(onNext: { [self] elapsedSeconds in
                let count = Config.OTP_VERIFICATION_COUNTDOWN_TIMER - elapsedSeconds
                codeSentText.accept(getFormattedTime(seconds:count))
            }, onCompleted: { [self] in
                self.showResendCode.accept(true)
            }).disposed(by: disposeBag)
    }
    func getFormattedTime(seconds:Int)->String{
        let (_,min,sec) = secondsToHoursMinutesSeconds(seconds)
        return String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
