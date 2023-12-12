//
//  ForgotPasswordUIController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation
import UIKit
import SnapKit

class ForgotPasswordViewController : ViewController<ForgotPasswordView,ForgotPasswordViewModel>{
    
    override func setupView() {
        binding.backButton.addOnClickListner { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
        
        binding.forgotPasswordButton.addOnClickListner{[unowned self] in
            self.viewModel.passwordResetToken()
        }
        
        viewModel.onPasswordResetToken.bind{
            VerifyPasswordResetViewController().apply({
                it in
                it.viewModel.email = self.viewModel.email.value
                self.navigationController?.pushViewController(it, animated: true)
            })
        }.disposed(by: disposeBag)
        
        bind(field: binding.emailField, relay: viewModel.email)
       
    }
    
}

