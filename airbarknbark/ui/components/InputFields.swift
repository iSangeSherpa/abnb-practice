//
//  InputFields.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import UIKit
import RxSwift


func OutlineInputField(label:String, hint:String? = nil ) -> MDCOutlinedTextField {
    
    return MDCOutlinedTextField().apply { inputField  in
        inputField.setNormalLabelColor(.onBackground.withAlphaComponent(0.5), for: .normal)
        inputField.font = .poppinsRegular(fontSize: 13)
        inputField.setOutlineColor(.onBackground.withAlphaComponent(0.3), for: .normal)
        inputField.setFloatingLabelColor(.primary, for: .editing)
        inputField.setFloatingLabelColor(.onBackground, for: .normal)
        inputField.setOutlineColor(.primary, for: .editing)
        inputField.containerRadius = Dimension.SINGLE_LINE_INPUT_FIELD_CORNOR_RADIUS
        inputField.verticalDensity = 0.4
        inputField.label.text = label
        inputField.label.font = .poppinsMedium(fontSize: 12)
        inputField.placeholder = hint ?? label
        inputField.preferredContainerHeight = Dimension.PRIMARY_BUTTON_HEIGHT.cgFloat
    }
}

func OutlineInputArea(hint:String) -> MDCOutlinedTextArea {
    
    return MDCOutlinedTextArea().apply {
        $0.setTextColor(.onBackground, for: .normal)
        $0.setNormalLabel(.onBackground.withAlphaComponent(0.5), for: .normal)
        $0.textView.font = .poppinsRegular(fontSize: 13)
        $0.setOutlineColor(.onBackground.withAlphaComponent(0.3), for: .normal)
        $0.setFloatingLabel(.primary, for: .editing)
        $0.setOutlineColor(.primary, for: .editing)
        $0.containerRadius = Dimension.SINGLE_LINE_INPUT_FIELD_CORNOR_RADIUS
        $0.verticalDensity = 0.4
        $0.label.text = hint
        $0.label.font = .poppinsMedium(fontSize: 12)
        $0.placeholder = hint
        $0.sizeToFit()
    }
}

func OutlineLabelOn(label:String? = nil, builder:(_ parent:UIView)->Void) -> UIView {
    
    let parent = UIView()
    
    let background = UIView().apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.15).cgColor
        it.layer.borderWidth = 1.5
        it.layer.cornerRadius = Dimension.DEFAULT_BUTTON_CORNER_RADIUS
        it.layer.zPosition = -1
    }
    
    if(label != nil){
        let label = TextBody(label: label!).apply { it in
            it.backgroundColor = .white
            it.layer.backgroundColor = UIColor.white.cgColor
            it.font = .poppinsMedium(fontSize: 12)
            it.eddgeInset = UIEdgeInsets(top: 0, left: Dimension.SIZE_8.cgFloat, bottom: 0, right: Dimension.SIZE_8.cgFloat)
        }
        parent.addSubViews(
            label
        )
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SCREEN_PADDING)
            make.centerY.equalTo(parent.snp.top)
        }
    }
    
    parent.addSubViews(
        background
    )
    
    background.snp.makeConstraints { make in
        make.edges.equalTo(parent)
    }
    
    builder(parent)
    
    return parent
}



extension MDCOutlinedTextField{
    
    func enablePasswordToggle(){
        
        let passwordHidden = UIImage(named: "ic_password_hidden")! as UIImage
        let passwordVisible = UIImage(named: "ic_password_visible")! as UIImage
        
        
        let toggleView = UIImageView(image: passwordHidden).apply{ [self] view in
            view.addOnClickListner {[unowned self] in
                self.isSecureTextEntry = !self.isSecureTextEntry
                view.image = self.isSecureTextEntry ? passwordHidden : passwordVisible
            }
            view.contentMode = .scaleAspectFit
            view.alpha = 0.2
            view.frame = CGRect(origin: .zero, size:CGSize(width: 20, height: 20))
        }
        self.trailingViewMode = .always
        self.trailingView = toggleView
        
    }
    
    func addTrailingView(view:UIView){
        self.trailingViewMode = .always
        self.trailingView = view
    }
    
    func addLeadingView(view:UIView){
        self.leadingViewMode = .always
        self.leadingView = view
    }
    
}

extension UITextField{
    
    func asPickerField(
        configBy: ((ViewWithPickerView<UITextField,UIPickerView>)->Void)? = nil
    ) -> ViewWithPickerView<UITextField, UIPickerView>{
        self.tintColor = .clear

        let pickerView = UIPickerView()
        
        self.inputView = pickerView
        
        let withPicker  = ViewWithPickerView.init(field: self, pickerView: pickerView)
        
        configBy?(withPicker)
        
        return withPicker
    }
    
    func asDatePickerField(
        configBy: ((ViewWithPickerView<UITextField,UIDatePicker>)->Void)? = nil
    ) -> ViewWithPickerView<UITextField, UIDatePicker>{
        let pickerView = UIDatePicker()
        
        pickerView.preferredDatePickerStyle  = .wheels
        pickerView.datePickerMode = .date
        self.tintColor = .clear
        
        self.inputView = pickerView
        
        let withPicker  = ViewWithPickerView.init(field: self, pickerView: pickerView)

        configBy?(withPicker)
        
        return withPicker
    }
}
