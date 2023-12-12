//
//  RegisterScreenViewControler.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation
import UIKit

class RegisterScreenViewController : ViewController<RegisterScreenView,RegisterScreenViewModel>{
    
    override func setupView() {
        
        binding.termsCheckBox.isChecked = false
        
        binding.backButton.addOnClickListner { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
        
        binding.bottomCaptionLoginButton.addOnClickListner { [unowned self] in
            
            navigationController?.pushViewController(LoginScreenViewController(), animated: true)
        }
        
        binding.registerButton.addOnClickListner { [unowned self] in
            viewModel.createUser()
        }
        
        viewModel.registrationAction.bind { [self] registrationSuccess in
            if(!registrationSuccess){
                return
            }
            let verifyOTPVC = VerifyOTPCodeViewController()
            verifyOTPVC.viewModel.password = viewModel.password.value
            self.navigationController?.pushViewController(verifyOTPVC, animated: true)
            }.disposed(by: disposeBag)
        
    
        bind(field: binding.emailField, relay: viewModel.email)
        bind(field: binding.passwordField, relay: viewModel.password)
        bind(field: binding.confirmPasswordField, relay: viewModel.confirmPassword)
        
        viewModel.acceptTerms.bind(to: binding.termsCheckBox.rx.isChecked).disposed(by: disposeBag)
        
        binding.termsCheckBox.rx.tapGesture().when(.recognized).bind{ _ in
            if(self.binding.termsCheckBox.isChecked){
                self.viewModel.acceptTerms.accept(false)
                return
            }
            
            AcceptTermsViewController().apply { it in
                self.navigationController?.present(it, animated: true)
            }.result().bind{ checkedResult in
                self.viewModel.acceptTerms.accept(checkedResult)
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
    }
}
