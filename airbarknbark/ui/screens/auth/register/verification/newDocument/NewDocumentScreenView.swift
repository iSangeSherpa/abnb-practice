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

class NewDocumentScreenView : BaseUIView{
    
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
        
    let title = TitleH2(label: "Document Details")
  
    
    let idNumberField = OutlineInputField(label: "Identification Number")
    let issuePlaceField = OutlineInputField(label: "Issued Place")

    let documentTypeField = OutlineInputField(label: "Document Type").apply { it in
        
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
        
        let title = TitleH3(label: "Document Photos").apply { it in
            it.textAlignment = .left
        }
        
        let caption = Caption(label: "Upload both front and back").apply { it in
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
        
    
    lazy var documentImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }
    
    lazy var imagesContainerView =  OutlineLabelOn(label: nil) { parent in
        
        parent.addSubViews(documentImageCollectionView, uploadPhotoView)
        
        documentImageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
        
        uploadPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }
    let drivingLicensInfo = InfoView(.NewDocument.addDrivingLicenseInfo)
   
    let documentInfo = InfoView(.NewDocument.legalDocInfoText)
    let continueButton  = PrimaryButton(label: "Add Document")
    
    lazy var containerStack = stack(
        backButtonWrapper,
        title,
        documentInfo,
        VSpacer(Dimension.SIZE_8),
        documentTypeField,
        VSpacer(Dimension.SIZE_8),
        idNumberField,
        VSpacer(Dimension.SIZE_8),
        issuePlaceField,
        VSpacer(Dimension.SIZE_8),
        imagesContainerView,
        drivingLicensInfo,
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
