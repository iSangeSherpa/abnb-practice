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

class RegisterVerificationScreenView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let rightIcon = UIImageView(image:UIImage(named: "ic_location_person")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    lazy var topStack = hstack(
        backButton,
        rightIcon.withWidth(40),
        distribution: .equalCentering
    )
    
    let scrollView  = UIScrollView().apply { it in
        it.keyboardDismissMode = .interactive
    }
    
    let layout  =  UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    let title = TitleH2(label: .RegisterVerification.verificationForm)
    
    let addressTrailingView = UIImageView(image:UIImage(named: "ic_location")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let addressDeleteView = UIImageView(image:UIImage(named: "ic_minus")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let addressLabel = Caption(label: "Address",font: .poppinsMedium(fontSize: 12))
    
    lazy var addressField = OutlineLabelOn(label: .RegisterVerification.addressOptional){ parent in
        let stack = hstack(addressLabel,
                           UIView(),
                           addressTrailingView,
                           UIView().withWidth(10),
                           addressDeleteView.withWidth(20).withHeight(20))
        parent.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalTo(parent).inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
        }
    }
    
    let addressFieldPressable = UIView()
    
    let addressInfo = InfoView(.EditProfile.addressInfo)
    
    let travellingInfoIcon = UIImageView(image:UIImage(named: "ic_plus")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let travellingInfoText = Caption(label: .RegisterVerification.iAmTraveller).apply { it in
        let text = it.text ?? ""
        it.textAlignment = .left
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.setAttributes([ .underlineStyle : NSUnderlineStyle.double.rawValue ], range: NSMakeRange(0,text.count))
        it.attributedText = attributedString
    }
    
    let isTravellingInfoImageView = UIImageView(image: UIImage(named: "ic_info")?.withTintColor(.onBackground.withAlphaComponent(0.6))).withSize(12)
    lazy var travellingInfoStack  = hstack(
        travellingInfoIcon.withSize(10),
        travellingInfoText,
        HSpacer(Dimension.SIZE_8),
        alignment: .center,
        distribution: .fill
    ).apply { it in
        it.enableRipple()
    }
    
    let emailFieldCheckIcon = UIImageView(image:UIImage(named: "ic_circle_check")!.scaledDown(into: .init(width: 20, height: 20))).apply { it in
        it.contentMode = .scaleToFill
    }
    
    lazy var  emailAddressField = OutlineInputField(label: .RegisterVerification.emailAdress).apply { it in
        it.keyboardType = .emailAddress
        it.addTrailingView(view: emailFieldCheckIcon)
    }
    
    let dateOfBirth = OutlineInputField(label: .RegisterVerification.dateOfBirthOptional, hint: .RegisterVerification.dateOfBirthHint)
    
    let contactNumberLeadingView = TextBody(label: "+61").apply { it in
//       let dropDown =  UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
//            it.contentMode = .scaleAspectFit
//        }
//        it.addSubview(dropDown)
//        dropDown.snp.makeConstraints { make in
//            make.left.equalTo(it.snp.right).offset(Dimension.SIZE_4)
//            make.centerY.equalTo(it)
//            make.width.height.equalTo(16)
//        }
    }
    
    let showMyNumberCheckbox = CheckBox().withSize(16)
    lazy var showMyNumberContainer = hstack(showMyNumberCheckbox,HSpacer(Dimension.SIZE_4),Caption(label: "Show my Number").apply({ it in
        it.textAlignment = .left
    }))

    lazy var contactNumber = OutlineInputField(label: .RegisterVerification.contactNumberOptional, hint: "").apply { it in
        it.keyboardType = .phonePad
        it.addLeadingView(view: contactNumberLeadingView)
    }
    
    lazy var emergencyContactLeadingView = TextBody(label: "+61")
    lazy var emergencyContact = OutlineInputField(label: .RegisterVerification.emergencyContactNumberOptional, hint: "").apply { it in
        it.keyboardType = .phonePad
        it.addLeadingView(view: emergencyContactLeadingView)
    }
    let emergencyContactInfo = InfoView(.RegisterVerification.emergencyContactNumberOptional)
    
    let plusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.withSize(62)
    }
    
    
    lazy var newDocumentView = UIView().apply { parent in
        
        let title = TitleH3(label:  .RegisterVerification.addLegalDocumentOptional).apply { it in
            it.textAlignment = .left
        }
        
        let caption = Caption(label: .RegisterVerification.fillLegalIdSection).apply { it in
            it.textAlignment = .left
            it.font = .poppinsRegular(fontSize: 10)
        }
        
        parent.addSubViews(plusIcon, title, caption)
        
        plusIcon.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SCREEN_PADDING)
            make.top.bottom.equalTo(parent)
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
        
        parent.enableRipple()
    }
    
    lazy var documentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }
    
    lazy var documentsContainer =  OutlineLabelOn(label: nil) { parent in
        
        parent.addSubViews(documentsCollectionView, newDocumentView)
        
        documentsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
        
        newDocumentView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }
    
    
    let termsCheckBox = CheckBox().withSize(20)
    
    let termsText = UITextView().apply() {
        
        $0.font = .captionLight
        $0.isEditable = false
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.isScrollEnabled = false
        $0.text = .RegisterVerification.dontHaveCriminalRecord
        $0.isUserInteractionEnabled = true
        $0.textContainerInset = .zero
        $0.sizeToFit()
    }
        
    lazy var termsWrapper = hstack(
        termsCheckBox,
        termsText,
        spacing: Dimension.SIZE_8.cgFloat,
        alignment: .firstBaseline,
        distribution: .fill
    )
    
    let continueButton  = PrimaryButton(label: .continue_)
    
    let idVerifiedInfo = InfoView(.RegisterVerification.idVerifiedInfoText).apply { it in
        it.isHidden = SessionManager.shared.userType == .FINDER
    }
    lazy var containerStack = stack(
        topStack.withMargins(.init(top: 0, left: -Dimension.SIZE_8.cgFloat, bottom: 0, right: 0)),
        title,
        VSpacer(Dimension.SIZE_8),
        addressField,
        addressInfo,
//        hstack(travellingInfoStack,isTravellingInfoImageView,UIView()),
        VSpacer(Dimension.SIZE_8),
        emailAddressField,
        VSpacer(Dimension.SIZE_8),
        dateOfBirth,
        VSpacer(Dimension.SIZE_8),
        showMyNumberContainer,
        VSpacer(Dimension.SIZE_2),
        contactNumber,
        VSpacer(Dimension.SIZE_8),
        emergencyContact,
        emergencyContactInfo,
        VSpacer(Dimension.SIZE_8),
        documentsContainer,
        idVerifiedInfo,
        VSpacer(Dimension.SIZE_8),
        termsWrapper,
        VSpacer(Dimension.SIZE_22),
        continueButton,
        spacing: Dimension.SIZE_12.cgFloat
    )
    
    override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubViews(containerStack, addressFieldPressable)
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
        
        addressFieldPressable.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(addressField)
            make.right.equalTo(addressDeleteView.snp.left).offset(-10)
        }
    }
    
  
    
}
