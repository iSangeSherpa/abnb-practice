//
//  MinderAllRequestsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/12/2022.
//

import Foundation
import UIKit

class MinderAllRequestsView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH2(label: .FinderAllRequests.requests)
    
    let scrollView  = UIScrollView().apply { it in
        it.translatesAutoresizingMaskIntoConstraints = true
    }
    
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
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_12),
        allRequestsCollection
    )
    
    let allRequestsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var allRequestsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: allRequestsLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(MindingRequestItemCell.self)
    }
    
    
    override func setupViews() {
        addSubViews(
            topStack,
            containerStack
        )
    }
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SIZE_16)
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
        allRequestsLayout.itemSize = .init(width: 160, height: 180)
    }
}
