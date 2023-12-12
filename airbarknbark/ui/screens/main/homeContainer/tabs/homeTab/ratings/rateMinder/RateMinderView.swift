//
//  RateMinderView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import UIKit

class RateMinderView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH3(label: .RatingsAndReviews.minderTitle)
    
    let starRatingView = StarRatingView()
    
    let reviewInputField = OutlineInputArea(hint: "Write a review").apply { it in
        it.preferredContainerHeight = 80
    }
    
    let plusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.withSize(62)
    }

    let addPhotos = TitleH3(label: .RatingsAndReviews.addPhotos)
    
    lazy var uploadPhotoView = UIView().apply { parent in
       
        let plusIcon1 = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
            it.contentMode = .scaleAspectFit
            it.withSize(62)
        }
        
        let title = TitleH3(label:  .NewPet.uploadPetPhoto).apply { it in
            it.textAlignment = .left
        }
        
        let caption = Caption(label:  .NewPet.canUploadMoreThanOne).apply { it in
            it.textAlignment = .left
            it.font = .poppinsRegular(fontSize: 10)
        }
        
        parent.addSubViews(plusIcon, plusIcon1, title,caption)
        
        plusIcon.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SCREEN_PADDING)
            make.top.bottom.equalTo(parent)
        }
        
        plusIcon1.snp.makeConstraints { make in
            make.centerX.equalTo(plusIcon.snp.trailing).offset(-Dimension.SIZE_8)
            make.top.bottom.equalTo(parent)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(plusIcon1.snp.trailing).offset(Dimension.SCREEN_PADDING)
            make.trailing.equalTo(parent).offset(-Dimension.SCREEN_PADDING)
            make.centerY.equalTo(parent).offset(-Dimension.SIZE_8)
        }
        
        caption.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.top.equalTo(title.snp.bottom)
        }
        
        parent.enableRipple()
    }
    
    let layout  =  UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }
    
    lazy var photosContainer =  OutlineLabelOn(label: nil) { parent in
        
        parent.addSubViews(photosCollectionView, uploadPhotoView)
        
        photosCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
                
        uploadPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }
    
    let submitReviewButton = PrimaryButton(label: "Submit Review")
    let bottomNote =  Caption(label: .RatingsAndReviews.feedbackNote,font: .poppinsMedium(fontSize: 11))
    
    lazy var bottomActionButtons = stack(
        VSpacer(Dimension.SIZE_22),
        submitReviewButton,
        VSpacer(Dimension.SIZE_4),
        bottomNote
    )
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_12),
        hstack(
            backButton,
            UIView()
        ).withMargins(.horizontal(-Dimension.SIZE_8.cgFloat)),
        VSpacer(Dimension.SIZE_22),
        title,
        VSpacer(Dimension.SIZE_22),
        starRatingView,
        VSpacer(Dimension.SIZE_22),
        reviewInputField,
        VSpacer(Dimension.SIZE_22),
        photosContainer,
        bottomActionButtons,
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    override func setupViews() {
        addSubViews(
            containerStack
        )
    }
    
    override func setupConstraints() {
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
    
    }
}

