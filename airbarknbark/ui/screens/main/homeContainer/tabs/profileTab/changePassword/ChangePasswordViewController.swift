//
//  ChangePasswordViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation

class ChangePasswordViewController : ViewController<ChangePasswordView,ChangePasswordViewModel>{
    
    override func setupView() {
        binding.backButton.addOnClickListner {[weak self] () in
            self?.navigationController?.popViewController(animated: true)
        }
        
        bind(field: binding.currentPasswordField, relay: viewModel.currentPassword)
        
        bind(field: binding.newPasswordField, relay: viewModel.newPassword)
        
        bind(field: binding.retypePasswordField, relay: viewModel.retypePassword)
        
        binding.changePasswordButton.addOnClickListner { [weak self] () in
            guard let self = self else {return}
            self.viewModel.changePassword()
        }
    
    }
}
