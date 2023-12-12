//
//  PetsWithAboutTableViewCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 30/03/2023.
//

import Foundation
import UIKit
import SDWebImage


class PetsWithAboutTableViewCell : BaseUITableViewCell {
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(50).apply{ it in
        it.layer.cornerRadius = (50)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "Fluffy",font:.captionSemiBold.withSize(12))
    let ageLabel = Caption(label: "3 years old",font:.captionSemiBold.withSize(12))
    let breedLabel = Caption(label: "German Shepard",font:.captionSemiBold.withSize(12))
    let immunizationStatusLabel = Caption(label: "Immunized",font:.captionSemiBold.withSize(12))
    let aboutLabel = Caption(label: "Fluffy",font:.captionSemiBold.withSize(12)).apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
    }
    
    let cellWrapper = UIView().apply ({ it in
        it.layer.cornerRadius = 10
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.backgroundColor = .surface
        it.enableRipple().rippleView.apply{ it in
            it.layer.cornerRadius = 10
            it.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(-Dimension.SIZE_2)
            }
        }
    })
    
    lazy var topSection =
    hstack(
        avatarImage,
        HSpacer(Dimension.SIZE_16),
        stack(
            UIView(),
            hstack(nameLabel,
                   HSpacer(8),
                   HDivider(verticalMargin: 4, alpha: 1),
                   HSpacer(8),
                   ageLabel,
                   HSpacer(8),
                   HDivider(verticalMargin: 4, alpha: 1),
                   HSpacer(8),
                   breedLabel,
                   UIView()
                  ),
            VSpacer(Dimension.SIZE_8),
            hstack(
                UIImageView(image: UIImage(named: "ic_circle_check")).withWidth(12).apply({ it in
                    it.contentMode = .scaleAspectFit
                }),
                HSpacer(8),
                immunizationStatusLabel,
                UIView()
            ),
            distribution: .equalCentering
        )
    ).withMargins(UIEdgeInsets(vertical: Dimension.SIZE_2.cgFloat, horizontal: Dimension.SIZE_16.cgFloat)).apply { it in
     
    }
    
    let vDivider = VDivider()
    let vSpacer = VSpacer(20)
    
    lazy var mainContainer = stack(
        VSpacer(Dimension.SIZE_12),
        topSection)
    
    override func setupViews(){
        self.contentView.addSubview(cellWrapper)
        self.contentView.addSubview(mainContainer)
        self.contentView.addSubview(aboutLabel)
        self.contentView.addSubview(vSpacer)
       
    }
    
    override func setupConstraints(){
        mainContainer.snp.makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
        }
        
        aboutLabel.snp.makeConstraints { make in
            make.top.equalTo(mainContainer.snp.bottom)
            make.bottom.equalTo(cellWrapper).offset(-10)
            make.left.equalTo(mainContainer).offset(50 + 16 + 12)
            make.right.equalTo(mainContainer).offset(-20)
            
        }
    
        vSpacer.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.SIZE_8)
            make.right.equalToSuperview().offset(-Dimension.SIZE_8)
        }
        cellWrapper.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(vSpacer.snp.centerY)
        }
        
    }
    
    func configure(model: PetDetails){
        self.nameLabel.text = model.name
        self.ageLabel.text =   "\(model.dob.asYearDate().ageYears()) years old"
        self.breedLabel.text = model.breed?.name
        self.immunizationStatusLabel.text = model.immunizationStatus ? "Immunized" : "Not Immunized"
        self.avatarImage.loadImage(src: model.images.first, type: .Pet)
        self.aboutLabel.text = model.about
    }
    
}




