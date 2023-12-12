//
//  BlockedUsersView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/02/2023.
//

import Foundation
import UIKit

class BlockedUsersView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH2(label: "Blocked users")
    
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
    
    
    let blockedUsersLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    let refreshControl = UIRefreshControl()
    
    
    lazy var blockedUsersCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: blockedUsersLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(BlockedUsersItemCell.self)
        collectionView.refreshControl = refreshControl
    }
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_12),
        blockedUsersCollection
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
        blockedUsersLayout.itemSize = .init(width: Int(Float(blockedUsersCollection.frame.width)), height: 90)
    }
}
