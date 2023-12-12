//
//  VerifyOTPCodeView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation
import UIKit

class VerifyOTPCodeView  : BaseUIView, UITextFieldDelegate{
    
    
    let topImage =  UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let backButton = UIButton().apply { it in
        it.withWidth(50)
        it.setBackgroundImage(UIImage(named: "ic_back_black"), for: .normal)
    }
    
    let titleText = TitleH1Bold(label: .VerifyOTP.otpVerification).apply {
        $0.textAlignment  = .left
    }
    
    let titleCaption = Caption(label: .VerifyOTP.desciption).apply {
        $0.textAlignment  = .left
        $0.font = .captionLight
    }
    
    
    let submitButton  = PrimaryButton(label:.VerifyOTP.submit )
    
    let bottomButtonRegister = TextButton(label: .Login.register, color: .primary)
    
    let optCodeItem = OutlineInputField(label: "").withSize(CGSize(width: 50, height: 60))
    
    lazy var optFields = [
        newOtpField(),
        newOtpField(),
        newOtpField(),
        newOtpField(),
        newOtpField(),
        newOtpField()
    ]
    
    lazy var optCodeField = hstack(
        spacing: Dimension.SIZE_8.cgFloat,
        alignment: .center,
        distribution: .equalSpacing
    ).apply { it in
        optFields.forEach { field in
            it.addArrangedSubview(field)
        }
    }
    
    func newOtpField() -> UITextField{
        return  UITextField().apply({ it in
            it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.2).cgColor
            it.layer.borderWidth = 1.3
            it.layer.cornerRadius = 2
            it.textAlignment = .center
            it.font = .poppinsSemibold(fontSize: 18)
            it.textColor = .onBackground
            it.delegate = self
            it.addTarget(self, action: #selector(optFieldDidChange(textField:)), for: .editingChanged)
            it.keyboardType = .numberPad
            
        }).withSize(CGSize(width: 50, height: 60));
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.2).cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 1
    }
    
    @objc final private func optFieldDidChange(textField: UITextField) {
        let curentFieldIndex  = optFields.firstIndex(of: textField)!
        
        let textCountInCurrentField : Int = textField.text?.count ?? 0
        
        let next = textCountInCurrentField == 0 ? (curentFieldIndex - 1) : (curentFieldIndex + 1);
        
        if(next>=0 && next < optFields.count){
            optFields[next].becomeFirstResponder()
        }
    }
    
    let resendCodeButton = UIButton().apply { it in
        
        it.titleLabel?.font = .poppinsRegular(fontSize: 14)
        
        let attributedRange = NSString(string: .VerifyOTP.resendCode).range(of: .VerifyOTP.resendCode, options: String.CompareOptions.caseInsensitive)
        
        let attributedText = NSMutableAttributedString.init(string:.VerifyOTP.resendCode)
        
        attributedText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue as Any],range: attributedRange)
        
        it.setAttributedTitle(attributedText, for: .normal)
        it.setAttributedTitle(attributedText,for: .selected)
        it.enableRipple().rippleView.apply{ it in
            it.layer.cornerRadius = 4
            it.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(-14)
                make.right.equalToSuperview().offset(14)
                make.top.equalToSuperview().offset(0)
                make.bottom.equalToSuperview().offset(0)
            }
        }
    }
    
    let codeSentLabel =  UILabel()
    
    func setCountdownText(remainingTime : String){
        let fullText = String.VerifyOTP.codeSent + remainingTime
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.setAttributes([.font : UIFont.poppinsSemibold(fontSize: 14), .foregroundColor : UIColor.primary], range: NSMakeRange(fullText.count-5, 5))
        codeSentLabel.textAlignment = .center
        codeSentLabel.font = .poppinsLight(fontSize: 14)
        codeSentLabel.attributedText = attributedString
    }
    
    
    lazy var resendCodeContainer = stack(
        hstack(UIView(),resendCodeButton,UIView(),spacing: Dimension.SIZE_4.cgFloat, distribution: .equalCentering),
        VSpacer(Dimension.SIZE_8),
        codeSentLabel
    )
    
    lazy var centerFieldsStack = stack(
        titleText,
        titleCaption,
        VSpacer(Dimension.SIZE_22),
        optCodeField,
        VSpacer(Dimension.SIZE_36),
        submitButton,
        VSpacer(Dimension.SIZE_8),
        resendCodeContainer,
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
