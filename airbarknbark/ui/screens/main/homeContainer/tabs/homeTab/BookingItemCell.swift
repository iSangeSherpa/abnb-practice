//
//  BookingItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class BookingItemCell : BaseUICollectionViewCell{
    let name = TitleH3(label: "John Doe")
   
    let dateLabel = Caption(label: "15 Jun",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let timeLabel = Caption(label: "10:00 - 14:00",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let rateLabel = TitleH3(label: "$15").apply({ it in
        it.textAlignment  = .center
        it.textColor = .primary
    })
    
    let perTimeLabel = Caption(label: "per hour",font:.captionMedium.withSize(10)).apply{ it in
        it.alpha = 0.75
        it.textAlignment  = .center
    }
    let avatarImage =  UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    
    let idVerifiedButton = IdVerifiedButton(showText: false)
    
    lazy var cellView = hstack(
        avatarImage,
        stack(
            hstack(
                name,
                idVerifiedButton,
                UIView(),
                spacing: Dimension.SIZE_8.cgFloat
            ),
            VSpacer(Dimension.SIZE_2),
            hstack(
                UIImageView(image: UIImage(named: "ic_calendar")).withWidth(12).apply({ it in
                    it.contentMode = .scaleAspectFit
                }),
                HSpacer(2),
                dateLabel,
                HSpacer(Dimension.SIZE_12),
                UIView(),
                spacing: Dimension.SIZE_2.cgFloat,
                distribution: .fill
            ),
            VSpacer(Dimension.SIZE_2),
            hstack(
                UIImageView(image: UIImage(named: "ic_clock")).withWidth(12).apply({ it in
                    it.contentMode = .scaleAspectFit
                }),
                HSpacer(2),
                timeLabel,
                UIView(),
                spacing: Dimension.SIZE_2.cgFloat
            )
        ).withMargins(.allSides(Dimension.SIZE_4.cgFloat)),
        stack(
            rateLabel,
            perTimeLabel
        ).withWidth(Dimension.SIZE_46.cgFloat)
            .withMargins(.init(vertical: Dimension.SIZE_12.cgFloat, horizontal: 0)),
        spacing: Dimension.SIZE_8.cgFloat
    ).apply { it in
        it.enableRipple().rippleView.apply{ it in
            it.layer.cornerRadius = 4
            it.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(-4)
            }
        }
    }

    let vDivider = VDivider()
    
    lazy var view = stack(UIView(),cellView,UIView())

    override func setupViews() {
        addSubViews(view,vDivider)
    }
    
    override func setupConstraints() {
        view.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.right.equalToSuperview()
        }
        vDivider.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottomMargin)
            make.left.right.equalToSuperview()
        }
    }
   
    func configure(model: BookingItem){
        name.text = model.name
        avatarImage.loadImage(src: model.imageURL, type: .User)
        
        dateLabel.text = model.date
        timeLabel.text = model.timeDuration
        rateLabel.text = model.rate
        perTimeLabel.text = model.perTime
        idVerifiedButton.isHidden = !model.isProfileVerified
    }
}
