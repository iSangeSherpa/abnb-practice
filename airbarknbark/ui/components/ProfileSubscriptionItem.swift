//
//  ProfileSubscriptionItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/07/2023.
//

import Foundation
import UIKit

class ProfileSubscriptionItem : BaseUIView{
    
    var plan : String = ""{
        willSet{
            planLabel.text = newValue
        }
    }
    
    lazy var planLabel = Caption(label: plan, font: .poppinsMedium(fontSize: 12)).apply { it in
        it.textColor = .primary
    }
    
    lazy var expiresDateLabel = Caption(label: "Expires on ", font: .poppinsMedium(fontSize: 12)).apply { it in
        it.textColor = UIColor(hexString: "#CB4040")
    }
    
    
    convenience init(plan : String){
        self.init()
        planLabel.text = plan
    }
    
    lazy var container = hstack(
        stack(
            Caption(label: "Payment Plan", font: .poppinsMedium(fontSize: 12)),
            hstack(planLabel,HSpacer(4), expiresDateLabel),
            alignment: .leading
        ),
        spacing:Dimension.SIZE_8.cgFloat,
        alignment: .center
    ).withMargins(.init(vertical: 20, horizontal: 20))
    .apply { it in
        it.layer.borderColor = UIColor.primary.cgColor
        it.layer.borderWidth = 2
        it.layer.cornerRadius = 8
        it.backgroundColor = .surface
        it.enableRipple().rippleView.layer.cornerRadius = 8

        it.addArrangedSubview(UIImageView(icon: "ic_arrow_right").withSize(16))
    }
    
    override func setupViews() {
        addSubViews(container)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}
