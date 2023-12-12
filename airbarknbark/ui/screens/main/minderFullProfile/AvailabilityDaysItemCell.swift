//
//  AvailabilityDaysItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 11/11/2022.
//

import Foundation
import UIKit

class AvailabilityDaysItemCell : BaseUICollectionViewCell{
    
    let imageViewChecked = UIImageView(image: UIImage(named: "ic_circle_check")).withSize(12)
    
    let dayLabel = TitleH3(label: "Sun")
    lazy var containerView =  UIView().apply { it in
        it.layer.borderColor = UIColor.primary.cgColor
        it.layer.borderWidth = 2
        it.layer.cornerRadius = 5
        it.addSubview(dayLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func setupViews() {
        addSubViews(imageViewChecked,containerView)
    }
    
    override func setupConstraints() {
        imageViewChecked.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageViewChecked.snp.bottom).offset(Dimension.SIZE_4)
            make.left.right.bottom.equalToSuperview()
        
        }
    }
    
    func configure(model : Selectable<AvailabilityDays>){
        dayLabel.text = model.item.day
        containerView.layer.borderColor = model.item.isAvailable ? UIColor.primary.cgColor : UIColor.onBackground.withAlphaComponent(0.08).cgColor
        imageViewChecked.isHidden = !model.isSelected
    }
}
