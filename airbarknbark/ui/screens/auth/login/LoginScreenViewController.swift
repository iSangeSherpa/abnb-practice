//
//  LoginScreenViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class LoginScreenViewController : ViewController<LoginScreenView, LoginScreenViewModel>{
    
    
    override func setupView() {
        binding.backButton.addOnClickListner { [unowned self] in
            
            guard let navigationStack = self.navigationController?.viewControllers, navigationStack.count > 1 else {
                self.view.window?.rootViewController =  UINavigationController( rootViewController: LandingScreenViewController())
                return
            }
            self.viewModel.dismissBy.accept(Void())
        }
        
        binding.bottomButtonRegister.addOnClickListner { [unowned self] in
            navigationController?.pushViewController(RegisterScreenViewController(), animated: true)
        }
        
        binding.forgotPaswordButton.addOnClickListner {[unowned self] in
            navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
            
        }
        
        binding.loginButton.addOnClickListner { [unowned self] in
            viewModel.login()
        }
        
        viewModel.loginAction.bind { [self] loginStatus in
            switch(loginStatus){
           
            case .Success:
                self.view.window?.rootViewController =  UINavigationController( rootViewController: HomeContainerScreenViewController())
            
            case .Unverified:
                self.navigationController?.pushViewController(VerifyOTPCodeViewController().apply({ it in
                    it.viewModel.fromRegister = false
                    it.viewModel.password = viewModel.password.value
                }), animated: true)
                
            case .IncompleteProfile:
                self.navigationController?.pushViewController(SetupProfileScreenViewController().apply({ it in
                    it.viewModel.forIncompleteProfile = true
                }), animated: true)
            }
           
        }.disposed(by: disposeBag)
        
        bind(field: binding.emailField, relay: viewModel.email)
        bind(field: binding.passwordField, relay: viewModel.password)
        
    }
    
}



