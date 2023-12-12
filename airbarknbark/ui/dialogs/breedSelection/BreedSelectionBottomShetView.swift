//
//  BreedSelectionBottomShetView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 19/12/2022.
//

import Foundation
import UIKit
import SnapKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas

class BreedSelectionBottomSheetView : BaseUIView {
    let crossButton  =  CrossButton(size: 22)
    
    let title = TitleH3(label: .Selectbreed.selectBreed).apply { it in
        it.font = .poppinsSemibold(fontSize: 18)
    }
    
    let searchField = OutlineInputField(label: .Selectbreed.searchBreed).apply { (it:MDCOutlinedTextField) in
        it.preferredContainerHeight = 46
        it.labelBehavior = MDCTextControlLabelBehavior.disappears
    }
    
    let addNewBreedLabel = TextBody(label: .Selectbreed.addNewBreed).apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
        it.textColor = .primary
        it.eddgeInset = .init(vertical: 16, horizontal: 16)
        it.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_4.cgFloat
    }
    
    let breedsCollectionViewLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var breedsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: breedsCollectionViewLayout
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(BreedCell.self)
    }
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_22),
        stack(
            hstack(
                title,
                UIView(),
                crossButton
            ),
            VSpacer(Dimension.SIZE_22),
            searchField
        ).withMargins(.horizontal(Dimension.SIZE_16.cgFloat)),
        VSpacer(Dimension.SIZE_4),
        breedsCollectionView,
        addNewBreedLabel,
        VSpacer(Dimension.SIZE_4),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    override func setupViews() {
        addSubViews(
            containerStack
        )
        self.layer.cornerRadius = Dimension.SIZE_16.cgFloat
        self.clipsToBounds = true
    }
    
    override func setupConstraints() {
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

    }
    
    override func layoutSubviews() {
        breedsCollectionViewLayout.itemSize = .init(width: Int(breedsCollectionView.frame.width) , height: Int(50))
        breedsCollectionViewLayout.minimumInteritemSpacing = .zero
        breedsCollectionViewLayout.minimumLineSpacing  = .zero
    }
}


class BreedCell : BaseUICollectionViewCell{
    
    let icon = UIImageView(icon: "ic_plus", tint: .primary)
    
    let label = TextBody(label: "").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
        it.eddgeInset = .horizontal(8)
    }
    
    lazy var stack = hstack(icon.withSize(12),label)
    let vDivider = VDivider()

    override func setupViews() {
        addSubViews(stack,vDivider)
        
        self.enableRipple()
        clipsToBounds = false
    }
    
    override func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(vertical: 0, horizontal: 16))
        }
        
        vDivider.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    func bind(item:ItemOrNew<Breed>){
        switch(item){
        case .Item(let breed):
            icon.isHidden = true
            label.text = breed.name
            label.textColor = .onBackground
            vDivider.isHidden = false
            self.alpha = 1
            break
        case .New:
            vDivider.isHidden = true
            icon.isHidden = false
            label.textColor = .primary
            label.text = .Selectbreed.addNewBreed
            self.alpha = 0.5
            break
        }
    }
    
}
