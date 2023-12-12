//
//  ChangePasswordView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit

class ChangePasswordView : BaseUIView{

    
    let backButton = BackButton()
    
    
    let titleText = TitleH1Bold(label: .ChangePassword.changePassword).apply {
        $0.textAlignment  = .left
    }
    
    
    let currentPasswordField = OutlineInputField(label: .ChangePassword.enterCurrentPassword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let newPasswordField = OutlineInputField(label: .ChangePassword.enterNewPassword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let passwordNote = UILabel().apply({ it in
        it.text = .ChangePassword.passwordNote
        it.font = .poppinsLight(fontSize: 12)
        it.numberOfLines = 0
        it.alpha = 0.6
    })
    
    let retypePasswordField = OutlineInputField(label: .ChangePassword.retypeNewPassword).apply {
        $0.isSecureTextEntry = true
        $0.enablePasswordToggle()
    }
    
    let changePasswordButton  = PrimaryButton(label:.ChangePassword.changePassword )
    
    lazy var centerFieldsStack = stack(
        VSpacer(Dimension.SIZE_8),
        titleText,
        VSpacer(Dimension.SIZE_22),
        currentPasswordField,
        VSpacer(Dimension.SIZE_16),
        newPasswordField,
        VSpacer(Dimension.SIZE_16),
        hstack(HSpacer(4),
            stack(
                VSpacer(Dimension.SIZE_4),
                UIImageView(image: UIImage(named: "ic_info")?.withTintColor(.onBackground.withAlphaComponent(0.6))).withSize(12),
                UIView()),
            passwordNote,
               HSpacer(4),
            spacing: Dimension.SIZE_8.cgFloat),
        VSpacer(Dimension.SIZE_16),
        retypePasswordField,
        VSpacer(Dimension.SIZE_16),
        changePasswordButton,
        spacing: CGFloat(Dimension.SIZE_4.cgFloat)
    )
    
    
    override func setupViews() {
        addSubViews(backButton,centerFieldsStack)
    }
    
    override func setupConstraints() {
       
        backButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(Dimension.SIZE_8)
            make.top.equalToSuperview().offset(100)
        }
        
        centerFieldsStack.snp.makeConstraints { make in
            make.left.equalTo(self).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self).offset(-Dimension.SCREEN_PADDING)
            make.top.equalTo(backButton.snp.bottom)
        }
        
        
    }
    
}
