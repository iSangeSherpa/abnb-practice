//
//  ResetPasswordViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 24/02/2023.
//

import Foundation
import UIKit

class ResetPasswordViewController: ViewController<ResetPasswordView,ResetPasswordViewModel>{
    
    override func setupView() {
        binding.backButton.addOnClickListner { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
        
        binding.forgotPasswordButton.addOnClickListner{[unowned self] in
            self.viewModel.resetPassword()
        }
        
        viewModel.onPasswordResetSuccess.bind{
            self.alert(alertText: "Success", alertMessage: "Your password has been changed successfully.", handler:{_ in
                self.view.window?.rootViewController =  UINavigationController( rootViewController: LoginScreenViewController())
            })
        }.disposed(by: disposeBag)
        
        bind(field: binding.passwordField, relay: viewModel.password)
        bind(field: binding.retypePasswordField, relay: viewModel.retypePassword)
   
    }
    
}

