//
//  RateFinderView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import UIKit

class RateFinderView: BaseUIView{
    let backButton  =  BackButton()
    
    let title = TitleH3(label: .RatingsAndReviews.finderTitle)
    
    let finderStarRatingView = StarRatingView()
    
    let finderReviewInputField = OutlineInputArea(hint: "Write a review").apply { it in
        it.preferredContainerHeight = 80
    }
    
    let plusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.withSize(62)
    }
    
    let petsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var petsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: petsLayout
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PetItemCell.self)
    }
    
    let petStarRatingView = StarRatingView()
    let petImage = UIImageView().withSize(30).apply { it in
        it.image = UIImage(named: "user_placeholder")
        it.layer.cornerRadius = (30)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    
    lazy var imageWithRatingStack = hstack(
        stack(UIView(),petStarRatingView,UIView(),distribution: .equalCentering))
    let petReviewInputField = OutlineInputArea(hint: "Write a review").apply { it in
        it.preferredContainerHeight = 50
    }
    
    lazy var petReviewsContainer =  stack(
        VSpacer(Dimension.SIZE_12),
        imageWithRatingStack,
        VSpacer(Dimension.SIZE_4),
        petReviewInputField,
        VSpacer(Dimension.SIZE_12),
        spacing:Dimension.SIZE_8.cgFloat
    ).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.3).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 4
        
        petReviewInputField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SIZE_12)
        }
        imageWithRatingStack.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Dimension.SIZE_12)
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
//        hstack(
//            backButton,
//            UIView()
//        ).withMargins(.horizontal(-Dimension.SIZE_8.cgFloat)),
        VSpacer(Dimension.SIZE_22),
        title,
        VSpacer(Dimension.SIZE_22),
        finderStarRatingView,
        VSpacer(Dimension.SIZE_22),
        finderReviewInputField,
        VSpacer(Dimension.SIZE_22),
        TitleH3(label: .RatingsAndReviews.ratePetTitle),
        VSpacer(Dimension.SIZE_22),
        petsCollection,
        VSpacer(Dimension.SIZE_8),
        petReviewsContainer,
        VSpacer(Dimension.SIZE_16),
        bottomActionButtons,
        UIView(),
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
        petsCollection.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    override func layoutSubviews() {
        petsLayout.itemSize = .init(width: Int(petsCollection.frame.width) , height: Int(petsCollection.frame.height))
    }
}

