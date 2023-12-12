//
//  PastWorksItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class PastWorksItemCell : BaseUICollectionViewCell{
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "Fluffy",font: .poppinsSemibold(fontSize: 16)).withHeight(35).apply { it in
        it.textAlignment = .left
    }
    
    let dateLabel = Caption(label: "10 July")
    
    let timeDurationLabel = Caption(label: "10 July")
    
    lazy var timeContainer = hstack(
        UIImageView(image: UIImage(named: "ic_clock")).withSize(10),
        timeDurationLabel,
        UIView(),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    lazy var dateContainer = hstack(
        UIImageView(image: UIImage(named: "ic_calendar")).withHeight(10).withWidth(12),
        stack(UIView(),dateLabel,UIView(),distribution: .equalCentering),
        UIView(),
        spacing: Dimension.SIZE_2.cgFloat
    ).withHeight(12)
    
    let paymentLabel = TitleH3(label: "$240").apply { it in
        it.textColor = .primary
    }
    
    let idVerifiedButton = IdVerifiedButton(showText: false)

    lazy var mainContainer = hstack(
        stack(UIView(),avatarImage,UIView(),distribution: .equalCentering),
        HSpacer(Dimension.SIZE_16),
        stack(UIView(), hstack(
            nameLabel,
            idVerifiedButton,
            UIView(),
            spacing: Dimension.SIZE_8.cgFloat
        ),dateContainer,timeContainer,UIView(),distribution: .equalCentering),
        UIView().apply({ it in
            let totalReceivedCaption = Caption(label: "Total Received",font: .poppinsRegular(fontSize: 12))
            it.addSubViews(paymentLabel,
                           totalReceivedCaption)

            paymentLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(-Dimension.SIZE_8)
                make.right.equalToSuperview()
            }
            
            totalReceivedCaption.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.top.equalTo(paymentLabel.snp.bottom)
            }
        }),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    let vDivider = VDivider()
    override func setupViews() {
        addSubViews(mainContainer,vDivider)
    }
    
    override func setupConstraints() {
        
//        nameLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview().offset(-(nameLabel.frame.height + dateTimeContainer.frame.height)/2)
//        }
//        dateTimeContainer.snp.makeConstraints { make in
//            make.top.equalTo(nameLabel.snp.bottom)
//        }
        
        mainContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(85)
            make.centerY.equalToSuperview().offset(-Dimension.SIZE_4.cgFloat)
        }
        
        vDivider.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            
        }
    }
    
    func configure(model : PastWorksItem){
        nameLabel.text = model.name
        avatarImage.loadImage(src: model.imageURL, type: .User)
        dateLabel.text = model.date
        timeDurationLabel.text = model.time
        paymentLabel.text = model.totalReceived
        idVerifiedButton.isHidden = !model.isProfileVerified
    }
}

