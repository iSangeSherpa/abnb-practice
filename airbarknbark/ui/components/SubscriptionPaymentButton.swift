//
//  SubscriptionPaymentButton.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/07/2023.
//

import Foundation
import UIKit
import RxRelay

class SubscriptionPaymentButton : BaseUIView{
    
    var plan : String = "Monthly, Auto-renewable" {
        willSet{
            planCaption.text = "oldValue"
        }
    }
    var price : String = "$4.97 / Month"{
        willSet{
            priceCaption.text = newValue
        }
    }
    var isSelected: Bool = false {
        willSet{
            setSelected(isSelected: newValue)
        }
    }
    var isSubscribed: Bool = false {
        willSet{
            subscribedButton.isHidden = !newValue
        }
    }
    
    lazy var planCaption = Caption(label: plan, font: .poppinsRegular(fontSize: 13)).apply{ it in
        it.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    lazy var priceCaption = Caption(label: price, font: .poppinsSemibold(fontSize: 16))
    
    let subscribedButton  = PrimaryButton(label:"Subscribed").withHeight(30).apply { it in
        it.isHidden = true
    }
    
    lazy var onButtonPressed : BehaviorRelay<Bool> = BehaviorRelay(value: isSelected)
    
    convenience init(plan:String,price:String, isSelected:Bool, isSubscribed: Bool) {
        self.init()
        self.plan = plan
        self.price = price
        self.planCaption.text = plan
        self.priceCaption.text = price
        self.isSelected = isSelected
        self.isSubscribed = isSubscribed
        self.setSelected(isSelected : isSelected)
        self.subscribedButton.isHidden = !isSubscribed

    }
    
    func setSelected(isSelected:Bool){
        container.layer.borderWidth = 2
        container.layer.cornerRadius = 4
        container.backgroundColor = isSelected ? UIColor(hexString: "F9FFFC") : .surface
        container.layer.borderColor = isSelected ? UIColor.primary.cgColor : UIColor.black.withAlphaComponent(0.08).cgColor
    }
    
    lazy var container =  stack(
        planCaption,
        priceCaption,
        spacing:Dimension.SIZE_2.cgFloat,
        alignment: .leading,
        distribution: .equalSpacing
    ).withMargins(.init(vertical: 15, horizontal: 20))
        .apply { it in
            it.layer.borderWidth = 2
            it.layer.cornerRadius = 4
            it.enableRipple().rippleView.layer.cornerRadius = 8
        }
    
    override func setupViews() {
        self.addSubViews(container,subscribedButton)
        
        container.addOnClickListner {[unowned self] in
            self.isSelected = !self.isSelected
            self.onButtonPressed.accept(self.isSelected)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        subscribedButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
}
