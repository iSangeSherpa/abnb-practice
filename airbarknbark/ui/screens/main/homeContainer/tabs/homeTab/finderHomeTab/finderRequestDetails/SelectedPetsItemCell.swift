//
//  SelectedPetsItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 04/11/2022.
//

import Foundation
import UIKit
import SDWebImage
class SelectedPetsItemCell : BaseUICollectionViewCell{
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "Fluffy",font:.captionSemiBold.withSize(12))
    let ageLabel = Caption(label: "3 years old",font:.captionSemiBold.withSize(12))
    let breedLabel = Caption(label: "German Shepard",font:.captionSemiBold.withSize(12))
    let aboutLabel = Caption(label: "",font:.captionSemiBold.withSize(12))
    
    let immunizationStatusLabel = Caption(label: "Immunized",font:.captionSemiBold.withSize(12))
    
    lazy var mainContainer = stack(hstack(
        avatarImage,
        HSpacer(Dimension.SIZE_16),
        stack(
            VSpacer(Dimension.SIZE_4),
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
            aboutLabel.apply({ it in
                it.textAlignment = .left
            }),
            VSpacer(Dimension.SIZE_4),
            hstack(
                UIImageView(image: UIImage(named: "ic_circle_check")).withSize(12).apply({ it in
                    it.contentMode = .scaleAspectFit
                }),
                HSpacer(8),
                immunizationStatusLabel,
                UIView()
            ),
            VSpacer(Dimension.SIZE_4)
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
            make.centerY.equalToSuperview().offset(-Dimension.SIZE_4.cgFloat)
        }
    
        vDivider.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        
        }
    }
    
    func configure(model : PetDetails){
        self.nameLabel.text = model.name
        self.ageLabel.text = "\(model.dob.asYearDate().ageYears()) years old"
        self.breedLabel.text = model.breed?.name
        self.aboutLabel.text = model.about
        self.immunizationStatusLabel.text = model.immunizationStatus ? "Immunized" : "Not Immunized"
        self.avatarImage.loadImage(src: model.images.first, type: .Pet )
    }
}
