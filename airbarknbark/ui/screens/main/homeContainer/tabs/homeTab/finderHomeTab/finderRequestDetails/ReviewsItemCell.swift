//
//  ReviewsItemCellView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 04/11/2022.
//

import Foundation

import UIKit

class ReviewsItemCell : BaseUICollectionViewCell{
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "Fluffy",font: .poppinsSemibold(fontSize: 16), alpha: 0.7)
    let reviewLabel = Caption(label: .VerifyOTP.desciption).apply {
        $0.textAlignment  = .left
        $0.font = .captionLight
    }
    let ratingLabel =  Caption(label: "4.7",font: .poppinsSemibold(fontSize: 14), alpha: 0.7).apply { it in
        it.numberOfLines = 1
    }
    
   
    lazy var mainContainer = stack(hstack(
        stack(UIView(),avatarImage,UIView()),
        HSpacer(Dimension.SIZE_16),
        stack(
            VSpacer(Dimension.SIZE_4),
            hstack(nameLabel,
                   UIView(),
                   ratingLabel,
                   HSpacer(Dimension.SIZE_4),
                   UIImageView(icon: "ic_paw").withWidth(16)
                  ),
            VSpacer(Dimension.SIZE_4),
            reviewLabel
        )
    )).apply { it in
        it.enableRipple().rippleView.apply{ it in
            it.layer.cornerRadius = 8
            it.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(-Dimension.SIZE_2)
            }
        }
    }
  
    let vDivider = VDivider()
    override func setupViews() {
        addSubViews(mainContainer,vDivider)
    }
    
    override func setupConstraints() {
        mainContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(85)
            make.centerY.equalToSuperview().offset(-Dimension.SIZE_4.cgFloat)
        }
    
        vDivider.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        
        }
    }
    
    func configure(model : ReviewsItem){
        nameLabel.text = model.name
        reviewLabel.text = model.review
        ratingLabel.text = model.rating
    }
}

