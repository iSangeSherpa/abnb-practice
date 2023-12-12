//
//  AllReviewsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation
import UIKit

class AllReviewsView : BaseUIView{
    let backButton  =  BackButton()
    
    let title = TitleH2(label: .Reviews.reviews)
    
    lazy var topStack = stack(
        hstack(
            backButton,
            UIView(),
            distribution: .fill
        ).withMargins(.horizontal(-Dimension.SIZE_8.cgFloat)),
        title,
        spacing: Dimension.SIZE_12.cgFloat,
        alignment: .leading
    )
    
    
    let allReviewsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var allReviewsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: allReviewsLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(ReviewsItemCell.self)
    }
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_12),
        allReviewsCollection
    )
    
    override func setupViews() {
        addSubViews(
            topStack,
            containerStack
        )
    }
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.top.equalTo(self.snp.topMargin).inset(Dimension.SCREEN_PADDING)
        }

        containerStack.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

    }
    
    override func layoutSubviews() {
        allReviewsLayout.itemSize = .init(width: Int(Float(allReviewsCollection.frame.width)), height: 90)
    }
}

