//
//  VerifyResetTokenViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/12/2022.
//

import Foundation
import UIKit

class VerifyPasswordResetViewController: ViewController<VerifyPasswordResetView,VerifyPasswordResetViewModel>{
    
    override func setupView() {
        binding.backButton.addOnClickListner { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
        
        binding.submitButton.addOnClickListner { [unowned self] in
            viewModel.resetPassword()
        }
        
        for i in 0...binding.optFields.count-1{
            bind(field: binding.optFields[i], relay: viewModel.otpFields[i])
        }
        
        viewModel.verifyAction.bind{
            [self] verificationStatus in
            ResetPasswordViewController().apply({
                it in
                it.viewModel.email.accept(self.viewModel.email)
                it.viewModel.otpCode.accept(self.viewModel.getOtpCode())
                self.navigationController?.pushViewController(it, animated: true)
            })
           
        }.disposed(by: disposeBag)
        
        viewModel.showResendCode.bind{
            self.binding.resendCodeButton.isHidden = !$0
            self.binding.codeSentLabel.isHidden = $0
        }.disposed(by: disposeBag)
        
        viewModel.codeSentText.bind{ [self] text in
            self.binding.setCountdownText(remainingTime: text)
        }.disposed(by: disposeBag)
        
    
        binding.resendCodeButton.addOnClickListner {[unowned self] in
            self.viewModel.resendPasswordResetToken()
        }
    }
    
}
