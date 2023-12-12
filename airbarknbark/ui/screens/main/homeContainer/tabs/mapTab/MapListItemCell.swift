//
//  MapListItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class MapListItemCell : BaseUICollectionViewCell{
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let titleLabel = TitleH3(label: "John Doe").apply({ it in
        it.font = .poppinsMedium(fontSize: 16)
    })
    let pathDistanceLabel = Caption(label: "2.3 km away",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    let idVerifiedButton = IdVerifiedButton()
    
    lazy var titleContainer = hstack(
        titleLabel,
        idVerifiedButton,
        UIView(),
        UIImageView(image: UIImage(named: "ic_path_distance")).withSize(16).apply({ it in
            it.contentMode = .scaleAspectFit
        }),
        pathDistanceLabel,
        spacing: Dimension.SIZE_8.cgFloat,
        alignment: .center
    )
    let ratingLabel =  Caption(label: "4.7",font: .poppinsSemibold(fontSize: 12), alpha: 0.7).apply { it in
        it.numberOfLines = 1
    }
    let expLabel =  Caption(label: "1 Year Exp",font: .poppinsSemibold(fontSize: 12), alpha: 0.7).apply { it in
        it.numberOfLines = 1
    }
    
    lazy var statContainer = hstack(
        UIImageView(icon: "ic_paw").withWidth(16),
        ratingLabel,
        HDivider(verticalMargin: 8),
        UIImageView(icon: "ic_briefcase",tint: UIColor(hexString: "#888888")).withWidth(14),
        expLabel,
        UIView(),
        spacing: Dimension.SIZE_8.cgFloat
    )
    lazy var availabilityContainer = hstack(
        UIImageView(icon: "ic_calendar_check").withWidth(12),
        Caption(label: "Sun",font: .poppinsMedium(fontSize: 12), alpha: 0.7),
        HDivider(verticalMargin: 8),
        Caption(label: "Mon",font: .poppinsMedium(fontSize: 12), alpha: 0.7),
        HDivider(verticalMargin: 8),
        Caption(label: "Thu",font: .poppinsMedium(fontSize: 12), alpha: 0.7),
        UIView(),
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    let rateLabel = TitleH3(label: "$40").apply{ it in
        it.font = .poppinsSemibold(fontSize: 22)
        it.textColor = .primary
    }
    let rateTypeLabel = Caption(label: "per hour",font: .poppinsMedium(fontSize: 10), alpha: 0.7)
    lazy var priceContainer = stack(
        rateLabel,
        rateTypeLabel,
        UIView(),
        alignment: .center
    )
    
    let dialerBtton = ButtonBox(icon: UIImage(named: "ic_dialer")?.withTintColor(.primary),size: 46)
    let mailButton = ButtonBox(icon: UIImage(named: "ic_mail")?.withTintColor(.primary), size: 46)
    
    let  createRequestButton = PrimaryButton(label: "+  Create Request", height: 46)
    lazy var actionContainer = hstack(
        dialerBtton,
        mailButton,
        createRequestButton,
        spacing: Dimension.SIZE_16.cgFloat,
        alignment: .center
    )
    
    lazy var vDivider = VDivider()
    
    lazy var view  = stack(
        hstack(
            stack(
                avatarImage,
                UIView(),
                spacing : Dimension.SIZE_4.cgFloat,
                distribution: .equalCentering
            ),
            stack(
                titleContainer,
                hstack(
                    stack(
                        statContainer,
                        availabilityContainer
                    ),
                    UIView(),
                    priceContainer
                )
            ),
            HSpacer(4),
            spacing: Dimension.SIZE_12.cgFloat,
            alignment: .fill
        ),
        actionContainer,
        spacing: Dimension.SIZE_16.cgFloat
    )
    override func setupViews() {
        addSubViews(view,vDivider)
    }
    
    override func setupConstraints() {
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.topMargin)
        }
        vDivider.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    func configure(model : MapListItem){
        titleLabel.text = model.name
        pathDistanceLabel.text = model.distance.0
        ratingLabel.text = model.rating
        rateLabel.text = model.perHourRate
        expLabel.text = model.experience
        avatarImage.loadImage(src: model.imageURL, type: .User)
        idVerifiedButton.isHidden = !model.isProfileVerified
    }
    
}
