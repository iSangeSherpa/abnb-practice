//
//  LoginScreenView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import UIKit
import SnapKit

class LoginScreenView  : BaseUIView {
    
    let topImage =  UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let backButton = UIButton().apply { it in
        it.withWidth(50)
        it.setBackgroundImage(UIImage(named: "ic_back_black"), for: .normal)
    }
    
    let titleText = TitleH1Bold(label: .Login.welcomeBack).apply {
        $0.textAlignment  = .left
    }
    
    let emailField = OutlineInputField(label:.Login.emailAdress).apply {
        $0.keyboardType = .emailAddress
    }
    
    let passwordField = OutlineInputField(label: .Login.pasword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    
    let forgotPaswordButton : UIButton = TextButton(label:.Login.forgotPassword)
        .apply{ it in
            it.titleLabel?.font = .captionMedium.withSize(13)
        }
    
    private lazy var forgotPaswordWrapper = forgotPaswordButton
        .wrapInUIView{ (container,it) in
            it.snp.makeConstraints { make in
                make.right.equalTo(container)
            }
        }.withHeight(40)
    
    let loginButton  = PrimaryButton(label:.Login.login )
    
    let bottomCaption =  Caption(label: .Login.dontHaveAccount, color: .onBackground)
    
    let bottomButtonRegister = TextButton(label: .Login.register, color: .primary)
    
    lazy var bottomContainer = hstack(
        bottomCaption,
        bottomButtonRegister,
        spacing:Dimension.SIZE_4.cgFloat,
        alignment: .center,
        distribution: .fill
    )
    

    lazy var centerFieldsStack = stack(
        titleText,
        VSpacer(Dimension.SIZE_22),
        emailField,
        VSpacer(Dimension.SIZE_16),
        passwordField,
        forgotPaswordWrapper,
        VSpacer(Dimension.SIZE_36),
        loginButton,
        spacing: CGFloat(Dimension.SIZE_4.cgFloat)
    )
    
    
    override func setupViews() {
        addSubview(topImage)
        addSubview(backButton)
        addSubview(titleText)
        addSubview(centerFieldsStack)
        addSubview(bottomContainer)
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
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(centerFieldsStack.snp.bottom).offset(Dimension.SIZE_16)
            make.centerX.equalTo(self)
        }
        
    }
    
}
