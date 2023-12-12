//
//  BlockedUsersItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/02/2023.
//

import Foundation
import UIKit

class BlockedUsersItemCell: BaseUICollectionViewCell{
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "",font: .poppinsSemibold(fontSize: 16)).withHeight(35).apply { it in
        it.textAlignment = .left
        it.numberOfLines = 1
    }
    
    let addressLabel = Caption(label: "10 July").apply { it in
        it.textAlignment = .left
        it.numberOfLines = 1
        it.lineBreakMode = .byTruncatingTail
    }
    
    lazy var addressContainer = hstack(
        UIImageView(image: UIImage(named: "ic_location")).withSize(10),
        HSpacer(Dimension.SIZE_4),
        addressLabel,
        UIView(),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    lazy var unblockButton = PrimaryButton(label: "Unblock",height: 30).apply { it in
        it.backgroundColor = .maroon
        it.configuration?.baseBackgroundColor = .maroon
        it.titleLabel?.numberOfLines = 1
    }.withWidth(80)
    

    lazy var mainContainer = hstack(
        stack(UIView(),avatarImage,UIView(),distribution: .equalCentering),
        HSpacer(Dimension.SIZE_16),
        stack(UIView(),hstack(nameLabel,UIView()),addressContainer,UIView(),distribution: .equalCentering),
        stack(UIView(),unblockButton,UIView(),distribution: .equalCentering),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
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
    
    func configure(model : BlockedUserDetails){
        nameLabel.text = model.fullName
        addressLabel.text = model.address?.name ?? "-"
        avatarImage.loadImage(src: model.image, type: .User)
    }
}
