//
//  CheckBox.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

struct LabelledCheckBox{
    var parent:UIView
    var checkBox:CheckBox;
    var label:UILabel
}

func CheckBoxWithLabel(
    label:String,
    checkedImage:String = "ic_checkbox_checked",
    uncheckdImage:String = "ic_checkbox_unchecked",
    parent:UIView = UIView()
)-> LabelledCheckBox{
    
    let checkbox = CheckBox(checkedImage:  UIImage(named: checkedImage)!, uncheckedImage:  UIImage(named: uncheckdImage)!).apply { it in
        it.withSize(20)
    }
    
    let label = Caption(label: label).apply { it in
        it.textAlignment = .left
    }
    
    parent.apply { it in
        it.addSubViews(checkbox, label)
    }
    
    checkbox.snp.makeConstraints { make in
        make.leading.equalTo(parent)
        make.top.bottom.equalTo(parent)
    }
    
    label.snp.makeConstraints { make in
        make.leading.equalTo(checkbox.snp.trailing).offset(Dimension.SIZE_8)
        make.top.bottom.equalTo(checkbox)
        make.trailing.equalTo(parent.snp.trailing)
    }
    
    let rippleView = checkbox.enableRipple(style: .unbounded)
    
    parent.addOnClickListner {
        checkbox.toggleCheckedStatus()
    }
    
    return LabelledCheckBox(parent: parent, checkBox: checkbox, label: label)
}

public class CheckBox: UIButton {
    // Images
    var checkedImage : UIImage = UIImage(named: "ic_checkbox_checked")! as UIImage
    var uncheckedImage : UIImage = UIImage(named: "ic_checkbox_unchecked")! as UIImage
    
    public var checkChangeListner : ((Bool) -> Void)?
    
    // Bool property
    public  var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(checkedImage:UIImage, uncheckedImage:UIImage) {
        self.init(frame: CGRect.zero)
        self.checkedImage = checkedImage;
        self.uncheckedImage = uncheckedImage;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
              
        addOnClickListner(action:self.toggleCheckedStatus)
    }
    
    func toggleCheckedStatus(){
        isChecked = !isChecked
        checkChangeListner?(isChecked)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.isChecked = true ? isChecked : isChecked
        imageView?.contentMode = .scaleAspectFit
    }
    
    func setCheckChangeListner(listner: @escaping (Bool)->Void){
        self.checkChangeListner = listner
    }
}


extension Reactive where Base: CheckBox {
    
    
    public var checkChanges: ControlEvent<Bool> {
        
        get{
            let source : Observable<Bool> =  Observable.create { [weak control = self.base] observer in
                guard let control = control else {
                    observer.on(.completed)
                    return Disposables.create()
                }
                
                control.checkChangeListner = { isChecked  in
                    observer.on(.next(isChecked))
                }
                
                return Disposables.create {
                    control.checkChangeListner = nil
                }
            }
            .take(until: self.deallocated)
            .share()
            
            return ControlEvent(events: source)
        }
        
        set{
            
        }
    }
}


