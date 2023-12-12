//
//  ForgotPasswordView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation
import UIKit

class ForgotPasswordView  : BaseUIView {
    
    let topImage =  UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let backButton = BackButton()

    
    let titleText = TitleH1Bold(label: .ForgotPassword.enterPassword).apply {
        $0.textAlignment  = .left
    }
    
    let emailField = OutlineInputField(label: .Login.emailAdress)
    
    let forgotPasswordButton  = PrimaryButton(label:.ForgotPassword.resetPassword )
    
    lazy var centerFieldsStack = stack(
        titleText,
        VSpacer(Dimension.SIZE_22),
        emailField,
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
