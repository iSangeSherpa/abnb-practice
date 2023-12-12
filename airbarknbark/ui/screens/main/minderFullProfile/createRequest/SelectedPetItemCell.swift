//
//  SelectedPetItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit

class SelectedPetItemCell : BaseUICollectionViewCell{
    
    let imageViewChecked = UIImageView(image: UIImage(named: "ic_circle_check")?.withTintColor(.primary) ).withSize(12)
    
    let imageView = UIImageView(image: UIImage(named: "user_placeholder")).withSize(55).apply { it in
        it.layer.cornerRadius = (55)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    
    let petNameLabel = Caption(label: "Fluffy", font: .poppinsMedium(fontSize: 12))
    
    lazy var containerView = stack(
        VSpacer(Dimension.SIZE_8),
        imageView,VSpacer(Dimension.SIZE_2),
        petNameLabel,
        alignment: .center).apply { it in
            it.layer.borderWidth = 2
            it.layer.cornerRadius = 5
    }
    
    override func setupViews() {
        addSubViews(imageViewChecked, containerView)
    }
    
    override func setupConstraints() {
        imageViewChecked.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageViewChecked.snp.bottom).offset(Dimension.SIZE_4)
            make.bottom.equalToSuperview().inset(Dimension.SIZE_4)
            make.left.equalToSuperview().inset(Dimension.SIZE_4)
            make.right.equalToSuperview().inset(Dimension.SIZE_4)
        }
    }
    
    func configure(model : Selectable<Pet>){
        petNameLabel.text = model.item.name
        containerView.layer.borderColor = model.isSelected ? UIColor.primary.cgColor : UIColor.onBackground.withAlphaComponent(0.08).cgColor
        
        imageViewChecked.isHidden = !model.isSelected
        containerView.layer.opacity = model.isSelected ? 1 : 0.5
        imageView.loadImage(src: model.item.images.first,type: .Pet)
    }
}
