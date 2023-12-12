//
//  ActiveMindingItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class ActiveMindingItemCell:BaseUICollectionViewCell{
    
    lazy var imageView = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60)
    
    lazy var imageWithProgressBar  = ProgressBackground().apply{ it in
        it.arcFillColor = .secondary
        it.addSubview(imageView)
        
        imageView.backgroundColor  = .background
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.background.cgColor
        imageView.layer.cornerRadius = (60)/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    lazy var nameLabel = TitleH3(label: "John Doe").apply { it in
        it.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
    }
    lazy var leftTimeLabel = TitleH3(label: "17 min left").apply { it in
        it.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
    }
    lazy var locationLabel = Caption(label: "California, US",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    lazy var startedFromLabel = Caption(label: "Started from: 12:00 am",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let idVerifiedButton = IdVerifiedButton(showText: false)
    
    lazy var detailStack = stack(
        hstack(
            nameLabel,
            idVerifiedButton,
            UIView(),
            leftTimeLabel.apply({ it in
                it.textColor = .primary
            }),
            spacing: Dimension.SIZE_8.cgFloat
        ),
        UIView(),
        hstack(
            UIImageView(image: UIImage(named: "ic_location")).withWidth(12).apply({ it in
                it.contentMode = .scaleAspectFit
            }),
            HSpacer(2),
            locationLabel,
            UIView(),
            startedFromLabel,
            spacing: Dimension.SIZE_2.cgFloat,
            distribution: .fill
        )
    ).withMargins(.allSides(Dimension.SIZE_8.cgFloat))
    
    lazy var cellStack = hstack(
        imageWithProgressBar,
        detailStack,
        spacing: Dimension.SIZE_8.cgFloat
    ).apply { it in
        it.enableRipple().rippleView.apply{ it in
            it.layer.cornerRadius = 4
            it.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(-Dimension.SIZE_8)
            }
        }
    }
    
    lazy var view = stack(UIView(),cellStack,UIView())
    
    lazy var vDivider = VDivider()
    
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
    
    func configure(model: MindingItem){
        nameLabel.text = model.name
        imageView.loadImage(src: model.imageURL, type : .User)
        
        leftTimeLabel.text = model.leftTime
        locationLabel.text = model.location
        startedFromLabel.text = model.startedTime
        idVerifiedButton.isHidden = !model.isProfileVerified
    }
}
