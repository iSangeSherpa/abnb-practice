//
//  ResetPasswordView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 24/02/2023.
//

import Foundation
import UIKit
class ResetPasswordView : BaseUIView,UITextFieldDelegate{
    
    let topImage =  UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let backButton = BackButton()

    
    let titleText = TitleH1Bold(label: .ForgotPassword.enterPassword).apply {
        $0.textAlignment  = .left
    }
    
    let passwordField = OutlineInputField(label: .ForgotPassword.newPassword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let retypePasswordField = OutlineInputField(label: .ForgotPassword.reEnterNewPassword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let forgotPasswordButton  = PrimaryButton(label:.ForgotPassword.resetPassword )
    
    lazy var centerFieldsStack = stack(
        titleText,
        VSpacer(Dimension.SIZE_22),
        passwordField,
        VSpacer(Dimension.SIZE_16),
        retypePasswordField,
        VSpacer(Dimension.SIZE_16),
        forgotPasswordButton,
        spacing: CGFloat(Dimension.SIZE_4.cgFloat)
    )
    
    
    override func setupViews() {
        addSubview(topImage)
        addSubview(backButton)
        addSubview(titleText)
        addSubview(centerFieldsStack)
    }
    
    override func setupConstraints() {
        topImage.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self).multipliedBy(0.4)
            make.height.equalTo(topImage.snp.width)
        }
        
        
        backButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(Dimension.SIZE_8)
            make.top.equalTo(centerFieldsStack.snp.top).offset(-Dimension.SIZE_36)
        }
        
        centerFieldsStack.snp.makeConstraints { make in
            make.left.equalTo(self).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self).offset(-Dimension.SCREEN_PADDING)
            make.top.equalTo(topImage.snp.bottom).offset(Dimension.SIZE_36)
        }
    }
    
}
