//
//  SetupProfileScreenView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/09/2022.
//

import Foundation
import UIKit


class SetupProfileScreenView : BaseUIView{
    
    let backButton = BackButton()
    
    lazy var backButtonWrapper = backButton.wrapInUIView { container, child in
        child.snp.makeConstraints { make in
            make.left.equalTo(container.snp.left).offset(-Dimension.SIZE_8)
            make.top.equalTo(container.snp.top)
            make.bottom.equalTo(container.snp.bottom)
        }
    }
    
    let scrollView  = UIScrollView().apply { it in
        it.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let title = TitleH2(label: .SetupProfile.setupYourProfile)
    
    let fullNameInputField = OutlineInputField(label: .SetupProfile.fullName)
    
    let bioInputField = OutlineInputArea(hint: "Short Bio").apply { it in
        it.preferredContainerHeight = 150
    }
    
    let layout  =  UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var petsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }
    
    let plusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let userProfileImage = UIImageView(image:nil).apply { it in
        it.contentMode = .scaleAspectFill
        it.layer.cornerRadius = 30
        it.clipsToBounds = true
    }
    
    let maleCheckBox  = CheckBoxWithLabel(label: Gender.MALE.displayName())
    let femaleCheckBox  = CheckBoxWithLabel(label:Gender.FEMALE.displayName())
    let genderOtherCheckBox  = CheckBoxWithLabel(label: Gender.OTHER.displayName())
    
    lazy var genderContainer = OutlineLabelOn(label:.gender ) { parent in
    
        let stack = hstack(
            maleCheckBox.parent,
            femaleCheckBox.parent,
            genderOtherCheckBox.parent,
            spacing: Dimension.SIZE_16.cgFloat,
            alignment: .center,
            distribution: .fillEqually
        )
        
        parent.addSubViews(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SIZE_22)
            make.trailing.equalTo(parent).offset(-Dimension.SIZE_22)
            make.top.equalTo(parent).offset(Dimension.SIZE_22)
            make.bottom.equalTo(parent).offset(-Dimension.SIZE_22)
        }
    }
    
    lazy var uploadPhotoView = OutlineLabelOn(label: nil) { parent in
       
        parent.withHeight(96)
        parent.enableRipple()
        
        let title = TitleH3(label: .SetupProfile.uploadYourPhoto).apply { it in
            it.textAlignment = .left
        }
        
        let caption = Caption(label: .SetupProfile.setYourPhotoText).apply { it in
            it.textAlignment = .left
            it.font = .poppinsRegular(fontSize: 10)
        }
        
        parent.addSubViews(userProfileImage, plusIcon, title, caption)
       
        plusIcon.snp.makeConstraints { make in
            make.centerY.equalTo(parent)
            make.leading.top.bottom.equalTo(parent).inset(UIEdgeInsets.allSides(16))
            make.width.equalTo(plusIcon.snp.height)
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.centerY.equalTo(parent)
            make.leading.top.bottom.equalTo(parent).inset(UIEdgeInsets.allSides(16))
            make.width.equalTo(plusIcon.snp.height)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(plusIcon.snp.trailing).offset(Dimension.SCREEN_PADDING)
            make.trailing.equalTo(parent).offset(-Dimension.SCREEN_PADDING)
            make.centerY.equalTo(parent).offset(-Dimension.SIZE_8)
        }
        
        caption.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.top.equalTo(title.snp.bottom)
        }
    }
    
    let continueButton  = PrimaryButton(label: .SetupProfile.continue_)
    
    lazy var petsContainer =  OutlineLabelOn(label: .SetupProfile.myPets) { parent in
        
        parent.addSubViews(petsCollectionView)
        
        petsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
    }
    
    lazy var containerStack = stack(
        backButtonWrapper,
        title,
        VSpacer(Dimension.SIZE_8),
        uploadPhotoView,
        VSpacer(Dimension.SIZE_8),
        fullNameInputField,
        VSpacer(Dimension.SIZE_8),
        genderContainer,
        VSpacer(Dimension.SIZE_8),
        bioInputField,
        VSpacer(Dimension.SIZE_8),
        petsContainer,
        VSpacer(Dimension.SIZE_22),
        continueButton,
        spacing: Dimension.SIZE_12.cgFloat
    )
    
    
    override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(containerStack)
    }
    
    override func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
    }
}

