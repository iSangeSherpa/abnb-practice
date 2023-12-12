//
//  MinderAllBookingsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/12/2022.
//

import Foundation
import RxSwift
import RxRelay

class MinderAllBookingsView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH2(label: .FinderAllBokings.bookings)
    
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
    
    
    let allBookingsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var allBookingsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: allBookingsLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(BookingItemCell.self)
    }
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_12),
        allBookingsCollection
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
        allBookingsLayout.itemSize = .init(width: Int(Float(allBookingsCollection.frame.width)), height: 90)
    }
}

