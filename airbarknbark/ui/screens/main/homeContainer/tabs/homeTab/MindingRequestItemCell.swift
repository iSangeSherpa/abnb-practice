//
//  RequestsItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation
import UIKit
import SDWebImage


class MindingRequestItemCell: BaseUICollectionViewCell{
    let imageView = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply { it in
        it.layer.cornerRadius = 30
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    lazy var imageViewWrapper =  imageView.wrapInUIView { container, child in
        child.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }.withHeight(60)
    
    let name = TitleH3(label: "John Doe")
    
    let idVerifiedButton = IdVerifiedButton(showText: false)

    let dateView = Caption(label: "20th July, 2022",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
    }
    
    lazy var statusButton = PrimaryButtonOutline(
        label: mindingRequestStatus.getTitle(),
        borderColor: mindingRequestStatus.getColor(),
        font: .poppinsMedium(fontSize: 10),
        titleColor: mindingRequestStatus.getColor(),
        cornerRadius: 6,
        height: 32
    )
    
    var mindingRequestStatus : RequestStatus = .CANCELLED {
        didSet {
            statusButton.apply {
                $0.setTitle(mindingRequestStatus.getTitle(), for: .normal)
                $0.layer.borderWidth = 2
                $0.layer.borderColor = mindingRequestStatus.getColor().cgColor
                $0.setTitleColor(mindingRequestStatus.getColor(), for: .normal)
            }
        }
    }
    
    lazy var view = stack(
        stack(
            VSpacer(8),
            imageViewWrapper,
            VSpacer(5),
            hstack(
                name,
                idVerifiedButton,
                spacing: Dimension.SIZE_4.cgFloat
            ).wrapInUIView { container, child in
                child.snp.makeConstraints { make in
                    make.width.lessThanOrEqualToSuperview()
                    make.center.equalToSuperview()
                }
            },
            hstack(
                UIImageView(image: UIImage(named: "ic_calendar")).withWidth(12).apply{ it in
                    it.contentMode = .scaleAspectFit
                },
                dateView,
                spacing: Dimension.SIZE_4.cgFloat
            ).wrapInUIView { container, child in
                child.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                }
            },
            VSpacer(8)
        ).apply { it in
            it.enableRipple().rippleView.layer.cornerRadius = 6
        },
        VSpacer(4),
        hstack(
            HSpacer(4),
            statusButton,
            HSpacer(4)
        )
        
    ).withWidth(130)
    
    override func setupViews() {
        addSubview(view)
    }
    
    override func setupConstraints() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(model: MindingRequestItem){
        name.text = model.name
        imageView.loadImage(src: model.imageURL, type: .User)
        dateView.text = model.date
        mindingRequestStatus = model.requestStatus
        idVerifiedButton.isHidden = !model.isProfileVerified
    }
    
}
