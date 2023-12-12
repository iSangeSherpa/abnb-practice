//
//  PastWorksView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit

class PastWorksView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH2(label: "History")
    
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
    
    
    let pastWorksLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var pastWorksCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: pastWorksLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(PastWorksItemCell.self)
    }
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_12),
        pastWorksCollection
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
        pastWorksLayout.itemSize = .init(width: Int(Float(pastWorksCollection.frame.width)), height: 90)
    }
}
