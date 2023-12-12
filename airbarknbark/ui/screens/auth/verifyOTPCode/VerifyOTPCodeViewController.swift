//
//  VerifyOTPCodeViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation
import UIKit
import RxSwift

class VerifyOTPCodeViewController  : ViewController<VerifyOTPCodeView, VerifyOTPCodeViewModel>{
    
    override func setupView() {
        binding.backButton.addOnClickListner { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
        
        binding.submitButton.addOnClickListner { [unowned self] in
            viewModel.verifyEmail()
        }
        
        for i in 0...binding.optFields.count-1{
            bind(field: binding.optFields[i], relay: viewModel.otpFields[i])
        }
        
        viewModel.verifyAction.bind{
            [self] verificationStatus in
            if(!verificationStatus) {return}
            navigationController?.pushViewController(SetupProfileScreenViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.showResendCode.bind{
            self.binding.resendCodeButton.isHidden = !$0
            self.binding.codeSentLabel.isHidden = $0
        }.disposed(by: disposeBag)
        
        viewModel.codeSentText.bind{ [self] text in
            self.binding.setCountdownText(remainingTime: text)
        }.disposed(by: disposeBag)
        
        if(viewModel.fromRegister){
            viewModel.startResendCodeTimer()
        }
        
        binding.resendCodeButton.addOnClickListner {[unowned self] in
            self.viewModel.resendEmailVerificationToken()
        }
    }
    
}
