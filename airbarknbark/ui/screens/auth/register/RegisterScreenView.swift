//
//  RegisterScreenView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation

import Foundation
import UIKit
import SnapKit

class RegisterScreenView  : BaseUIView {
    
    let topImage =  UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let backButton = BackButton()
    
    let titleText = TitleH1Bold(label: .Register.gettingStarted).apply {
        $0.textAlignment  = .left
    }
    
    let emailField = OutlineInputField(label:.Register.emailAdress).apply {
        $0.keyboardType = .emailAddress
    }
    
    let passwordField = OutlineInputField(label: .Register.pasword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let confirmPasswordField = OutlineInputField(label: .Register.confirmPasword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let registerButton  = PrimaryButton(label:.Register.continue_)
    
    let bottomCaption =  Caption(label: .Register.alreadyHaveAccount, color: .onBackground, textAlignment: .center)
    
    let bottomCaptionLoginButton = TextButton(label: .Register.login, color: .primary)
    
    let termsCheckBox = CheckBox().withSize(20)
    
    let termsText = UITextView().apply() {
        
        let attributedString = NSMutableAttributedString(string: .Register.termsCaption)
        let url = URL(string: .Register.termsLink )!
//        attributedString.setAttributes([.link: url, .font : UIFont.poppinsSemibold(fontSize: 13), .foregroundColor : UIColor.primary], range: NSMakeRange(0, 0))
        $0.linkTextAttributes = [.foregroundColor: UIColor.primary]
        $0.textAlignment = .center
        $0.font = .poppinsLight(fontSize: 13)
        $0.isEditable = false
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.isScrollEnabled = false
        $0.attributedText = attributedString
        $0.isUserInteractionEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        $0.sizeToFit()
    }
        
    lazy var termsWrapper = hstack(
        termsCheckBox,
        termsText,
        spacing: Dimension.SIZE_8.cgFloat,
        alignment: .firstBaseline,
        distribution: .fill
    )
    
    
    lazy var bottomContainer = hstack(
        bottomCaption,
        bottomCaptionLoginButton,
        spacing:Dimension.SIZE_4.cgFloat,
        alignment: .center,
        distribution: .fill
    ).wrapInUIView { container, child in
        child.snp.makeConstraints { make in
            make.center.equalTo(container)
            make.top.equalTo(container)
            make.bottom.equalTo(container)
        }
    }
    
    
    lazy var centerFieldsStack = stack(
        titleText,
        VSpacer(Dimension.SIZE_22),
        emailField,
        VSpacer(Dimension.SIZE_16),
        passwordField,
        VSpacer(Dimension.SIZE_16),
        confirmPasswordField,
        VSpacer(Dimension.SIZE_8),
        termsWrapper,
        VSpacer(Dimension.SIZE_36),
        registerButton,
        VSpacer(Dimension.SIZE_16),
        bottomContainer,
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
