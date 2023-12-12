//
//  NewPetScreenView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 14/09/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewPetScreenView : BaseUIView{
    
    let backButton  =  BackButton()
    
    lazy var backButtonWrapper = backButton.wrapInUIView { container, child in
        child.snp.makeConstraints { make in
            make.left.equalTo(container.snp.left).offset(-Dimension.SIZE_8)
            make.top.equalTo(container.snp.top)
            make.bottom.equalTo(container.snp.bottom)
        }
    }
    
    let scrollView  = UIScrollView().apply { it in
        it.keyboardDismissMode = .interactive
    }
    
    let layout  =  UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
        
    let title = TitleH2(label:  .NewPet.petInformation)
    
    let petNameField = OutlineInputField(label: .NewPet.petName)
    
    lazy var dateOfBirth = OutlineInputField(label: .NewPet.dateOfBirth, hint: .NewPet.dateOfBirthHint)
    
    let aboutInputField = OutlineInputArea(hint: "About").apply { it in
        it.preferredContainerHeight = 100
    }
    
    let breedField = OutlineInputField(label:  .NewPet.chooseBreedType).apply { it in
        
        let trailingIcon = UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
            it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 16))
            it.contentMode = .scaleAspectFit
        }
        it.addTrailingView(view: trailingIcon)
    }
    
    let plusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.withSize(62)
    }
    

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
        let vaccinationCaption = Caption(label:  .NewPet.vaccinationCertificate).apply { it in
            it.textAlignment = .left
            it.font = .poppinsRegular(fontSize: 10)
        }
        
        parent.addSubViews(plusIcon, plusIcon1, title,caption,vaccinationCaption)
        
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
            make.centerY.equalTo(parent).offset(-Dimension.SIZE_12)
        }
        
        caption.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.top.equalTo(title.snp.bottom)
        }
        vaccinationCaption.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.top.equalTo(caption.snp.bottom)
        }
        
        parent.enableRipple()
    }
    
    lazy var petsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }
    
    lazy var petsContainer =  OutlineLabelOn(label: nil) { parent in
        
        parent.addSubViews(petsCollectionView, uploadPhotoView)
        
        petsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
                
        uploadPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }
    
    let yesCheckBox  = CheckBoxWithLabel(label: .yes, checkedImage: "ic_yes_selected", uncheckdImage: "ic_yes_unselected")
    let noChecBox  = CheckBoxWithLabel(label: .no, checkedImage: "ic_no_selected", uncheckdImage: "ic_no_unselected")
    
    lazy var imunizationStatus = OutlineLabelOn(label: "Immunization Status") { parent in
        
        let stack = hstack(yesCheckBox.parent,noChecBox.parent, spacing: Dimension.SIZE_16.cgFloat, alignment: .center, distribution: .fillEqually)
        
        parent.addSubViews(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SIZE_22)
            make.trailing.equalTo(parent).offset(-Dimension.SIZE_22)
            make.top.equalTo(parent).offset(Dimension.SIZE_22)
            make.bottom.equalTo(parent).offset(-Dimension.SIZE_22)
        }
    }
    
    let behaviourField = OutlineInputField(label: .NewPet.behaviour, hint: .NewPet.selectBehaviour).apply { it in

        let trailingIcon = UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
            it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 16))
            it.contentMode = .scaleAspectFit
        }

        it.addTrailingView(view: trailingIcon)
        
    }

    let personalityInfo = InfoView(.NewPet.personalityInfo)
    
    let includePhotoInfo = InfoView(.NewPet.vaccinationCertificate)
    
    let continueButton  = PrimaryButton(label: .continue_)

    lazy var containerStack = stack(
        title,
        VSpacer(Dimension.SIZE_8),
        petNameField,
        VSpacer(Dimension.SIZE_8),
        dateOfBirth,
        VSpacer(Dimension.SIZE_8),
        aboutInputField,
        VSpacer(Dimension.SIZE_8),
        breedField,
        VSpacer(Dimension.SIZE_8),
        imunizationStatus,
        VSpacer(Dimension.SIZE_8),
        behaviourField,
        personalityInfo,
        VSpacer(Dimension.SIZE_8),
        petsContainer,
        includePhotoInfo,
        VSpacer(Dimension.SIZE_22),
        continueButton,
        spacing: Dimension.SIZE_12.cgFloat
    )
    
    lazy var mainStack = stack(backButtonWrapper,VSpacer(Dimension.SIZE_4),containerStack)
    
    override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(mainStack)
    }
    
    override func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
    }
    
}
