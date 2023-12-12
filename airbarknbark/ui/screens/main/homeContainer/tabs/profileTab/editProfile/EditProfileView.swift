//
//  EditProfileView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 17/11/2022.
//

import Foundation
import UIKit

class EditProfileView : BaseUIView{
    
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
    
    lazy var userProfileImage = UIImageView(image: UIImage(named: "user_placeholder")).withSize(90).apply { it in
        it.contentMode = .scaleAspectFill
        it.layer.cornerRadius = 90/2
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
    
    
    let saveChangesButton  = PrimaryButton(label: .EditProfile.saveChanges)
    
    lazy var petsContainer =  OutlineLabelOn(label: .SetupProfile.myPets) { parent in
        
        parent.addSubViews(petsCollectionView)
        
        petsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
    }
    
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
    
    let dateOfBirth = OutlineInputField(label: .RegisterVerification.dateOfBirthOptional, hint: .RegisterVerification.dateOfBirthHint)
    
    let showMyNumberCheckbox = CheckBox().withSize(16)
    lazy var showMyNumberContainer = hstack(showMyNumberCheckbox,HSpacer(Dimension.SIZE_4),Caption(label: "Show my Number").apply({ it in
        it.textAlignment = .left
    }))
    
    let contactNumberLeadingView = TextBody(label: "+61").apply { it in }

    lazy var contactNumber = OutlineInputField(label: .RegisterVerification.contactNumberOptional, hint: "").apply { it in
        it.keyboardType = .phonePad
        it.addLeadingView(view: contactNumberLeadingView)
    }
    
    lazy var emergencyContactLeadingView = TextBody(label: "+61")
    lazy var emergencyContact = OutlineInputField(label: .RegisterVerification.emergencyContactNumberOptional, hint: "").apply { it in
        it.keyboardType = .phonePad
        it.addLeadingView(view: emergencyContactLeadingView)
    }
    let emergencyContactInfo = InfoView(.RegisterVerification.emergencyContactInfo)
    
    //MARK: Profile Setup View
    let availabilityLabel = Caption(label: .MinderProfileSetup.availability,font: .poppinsMedium(fontSize: 16))
    
    let availabilityInfo = InfoView(.MinderProfileSetup.availabilityInfo,false)
    
    let availableYesCheckBox  = CheckBoxWithLabel(label: .yes, checkedImage: "ic_yes_selected", uncheckdImage: "ic_yes_unselected")
    let availableNoChecBox  = CheckBoxWithLabel(label: .no, checkedImage: "ic_no_selected", uncheckdImage: "ic_no_unselected")
    
    lazy var availableContainer = OutlineLabelOn(label: .MinderProfileSetup.areYouAvailable) { parent in
        
        let stack = hstack(availableYesCheckBox.parent,availableNoChecBox.parent, spacing: Dimension.SIZE_16.cgFloat, alignment: .center, distribution: .fillEqually)
        
        parent.addSubViews(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalTo(parent).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
    }
        
    let availableDaysLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
        it.minimumLineSpacing = 0.2
        it.minimumInteritemSpacing = 0.2
        
    }
    
    lazy var availableDaysCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: availableDaysLayout
    ).apply { collectionView in
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(AvailableDayCell.self)
    }
    
    
    lazy var availableDaysContainer =  OutlineLabelOn(label: .MinderProfileSetup.availableWeekDays) { parent in
        
        parent.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
    }.wrapInUIView { container, child in
        // wrapping on another UIView so availableDaysCollection wouldn't overflow from parent's bound
        // important for  click handling on availableDaysCollection cells
        container.addSubview(availableDaysCollection)
        
        availableDaysCollection.snp.makeConstraints { make in
            make.left.right.equalTo(child).inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.centerY.equalTo(child.snp.bottom)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        child.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
        
    let workingHoursLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var workingHoursCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: workingHoursLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WorkingHourCell.self)
    }
    
    lazy var workingHoursContainer =  OutlineLabelOn(label: .MinderProfileSetup.workingHours) { parent in
        
        parent.addSubViews(workingHoursCollection)
        
        workingHoursCollection.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
        }
    }
    
    let travelingYesCheckBox  = CheckBoxWithLabel(label: .yes, checkedImage: "ic_yes_selected", uncheckdImage: "ic_yes_unselected")
    let travelingNoCheckBox  = CheckBoxWithLabel(label: .no, checkedImage: "ic_no_selected", uncheckdImage: "ic_no_unselected")
    
    lazy var travelingContainer = OutlineLabelOn(label: "Are you traveling?") { parent in
        
        let stack = hstack(travelingYesCheckBox.parent,travelingNoCheckBox.parent, spacing: Dimension.SIZE_16.cgFloat, alignment: .center, distribution: .fillEqually)
        
        parent.addSubViews(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalTo(parent).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
    }
    
    let vehiclePlusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.withSize(62)
    }
    
    lazy var newVehicleView = UIView().apply { parent in
        
        let title = TitleH3(label: "Vehicles").apply { it in
            it.textAlignment = .left
        }
        
        let caption = Caption(label: "Add new vehicle").apply { it in
            it.textAlignment = .left
            it.font = .poppinsRegular(fontSize: 10)
        }
        
        parent.addSubViews(vehiclePlusIcon, title,caption)
        
        vehiclePlusIcon.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SCREEN_PADDING)
            make.top.bottom.equalTo(parent)
        }
    
        title.snp.makeConstraints { make in
            make.leading.equalTo(vehiclePlusIcon.snp.trailing).offset(Dimension.SCREEN_PADDING)
            make.trailing.equalTo(parent).offset(-Dimension.SCREEN_PADDING)
            make.centerY.equalTo(parent).offset(-Dimension.SIZE_8)
        }
        
        caption.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.top.equalTo(title.snp.bottom)
        }
        
        parent.enableRipple()
    }
    
    
    let vehiclesLayout  =  UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var vehiclesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: vehiclesLayout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }
    
    lazy var vehiclesContainer =  OutlineLabelOn(label: "Vehicles") { parent in
        
        parent.addSubViews(vehiclesCollectionView, newVehicleView)
        
        vehiclesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
        
        newVehicleView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }
    
    
    let ratesLabel =  Caption(label: .MinderProfileSetup.rates,font: .poppinsMedium(fontSize: 16))
    
    let rateField  = OutlineInputField(label: .MinderProfileSetup.payPerService, hint: "").apply { it in
        it.keyboardType = .decimalPad
        it.addLeadingView(view: Caption(label: "$").apply{ it in
            it.textColor = .onBackground.withAlphaComponent(0.6)
        })
        
        it.addTrailingView(view: Caption(label: .MinderProfileSetup.perHour).apply{ it in
            it.textColor = .onBackground.withAlphaComponent(0.6)
        })
    }
    
    let experienceLabel =  Caption(label: .MinderProfileSetup.experience,font: .poppinsMedium(fontSize: 16))
    
    let yearsOfExperienceField  = OutlineInputField(label: .MinderProfileSetup.yearsOfExperience, hint: "0").apply { it in
        it.textAlignment = .center
        it.keyboardType = .numberPad
        
        it.addLeadingView(view: UIImageView(image: UIImage(named: "ic_minus_plain")))
        it.addTrailingView(view: UIImageView(image: UIImage(named: "ic_plus")?.scaledDown(into: .init(width: 10, height: 10))))
        
        it.trailingView?.enableRipple(style:.unbounded, factor:2)
        it.leadingView?.enableRipple(style:.unbounded, factor:1)
        
        it.trailingEdgePaddingOverride  = 20
        it.leadingEdgePaddingOverride  = 20
    }
    
    let noExperienceCheckbox = CheckBox()
    
    let noExperienceLabel = Caption(label: .MinderProfileSetup.noExperience)
    
    let preferencesLabel = Caption(label: .MinderProfileSetup.preferences,font: .poppinsMedium(fontSize: 16))
    
    let preferenceSmall = breedPreferenceItem(icon: "ic_dog_small", label: .MinderProfileSetup.dogSmall)
    let preferenceMedium = breedPreferenceItem(icon: "ic_dog_medium", label:.MinderProfileSetup.dogMedium)
    let preferenceLarge = breedPreferenceItem(icon: "ic_dog_large", label: .MinderProfileSetup.dogLarge)
    
    let breedPreferenceField  = OutlineInputField(label: .MinderProfileSetup.breedPreferences, hint: .MinderProfileSetup.chooseFromList).apply { it in
        let trailingIcon =  UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
            it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 16))
            it.contentMode = .scaleAspectFit
        }
        it.trailingEdgePaddingOverride = 16
        it.addTrailingView(view: trailingIcon)
    }
    
    let petBehaviourCollectionViewLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
        it.minimumLineSpacing = 1
        it.minimumInteritemSpacing = 1
    }
    
    lazy var petBehaviourCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: petBehaviourCollectionViewLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(PetBehaviourCell.self)
    }
    
    let manualPetbehaviour = OutlineInputField(label: .MinderProfileSetup.orWriteYourOwn).apply { it in
        it.labelBehavior = .disappears
    }
    
    lazy var petBehaviourContainer =  OutlineLabelOn(label: .MinderProfileSetup.petBehaviour) { parent in
        
        parent.addSubViews(petBehaviourCollectionView, manualPetbehaviour)
        
        petBehaviourCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.top.equalToSuperview().inset(Dimension.SIZE_16.cgFloat)
            make.left.right.equalToSuperview().inset(Dimension.SIZE_8.cgFloat)
            make.bottom.equalTo(manualPetbehaviour.snp.top).offset(-Dimension.SIZE_8)
        }
        
        manualPetbehaviour.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(Dimension.SIZE_16)
        }
    }
    
    lazy var minderProfileViewStack = stack(
        hstack(availabilityLabel,UIView()),
//        availabilityInfo,
        VSpacer(Dimension.SIZE_4),
        availableContainer,
//        VSpacer(Dimension.SIZE_8),
        availableDaysContainer,
//        VSpacer(Dimension.SIZE_22),
        workingHoursContainer,
//        VSpacer(Dimension.SIZE_8),
//        travelingContainer,
//        VSpacer(Dimension.SIZE_8),
//        vehiclesContainer,
        VSpacer(Dimension.SIZE_8),
        hstack(ratesLabel,UIView()),
        VSpacer(Dimension.SIZE_4),
        rateField,
        VSpacer(Dimension.SIZE_8),
        hstack(experienceLabel,UIView()),
        VSpacer(Dimension.SIZE_4),
        hstack(
            yearsOfExperienceField.withWidth(max(225,UIScreen.main.bounds.width * 0.5)),
            UIView(),
            noExperienceCheckbox.withWidth(50),
            noExperienceLabel,
            alignment: .center,
            distribution: .fill
        ),
        VSpacer(Dimension.SIZE_8),
        hstack(preferencesLabel,UIView()),
        stack(
            preferenceSmall,
            preferenceMedium,
            preferenceLarge
        ).withMargins(.init(top: 0, left: -Dimension.SIZE_8.cgFloat, bottom: 0, right: Dimension.SIZE_8.cgFloat)),
        VSpacer(Dimension.SIZE_8),
        breedPreferenceField,
        VSpacer(Dimension.SIZE_8),
        petBehaviourContainer,
        VSpacer(Dimension.SIZE_22),
        
        spacing: Dimension.SIZE_12.cgFloat
    )
    
    lazy var containerStack = stack(
        backButtonWrapper,
        VSpacer(50),
        InfoView(.EditProfile.photoInfo,false).wrapInUIView({ container, child in
            child.snp.makeConstraints { make in
                make.centerX.equalTo(container.snp.centerX)
            }
        }),
        VSpacer(Dimension.SIZE_8),
        fullNameInputField,
        VSpacer(Dimension.SIZE_8),
        genderContainer,
        VSpacer(Dimension.SIZE_8),
        bioInputField,
        VSpacer(Dimension.SIZE_8),
        petsContainer,
        VSpacer(Dimension.SIZE_8),
        addressField,
//        addressInfo,
        VSpacer(Dimension.SIZE_8),
        dateOfBirth,
        VSpacer(Dimension.SIZE_8),
        showMyNumberContainer,
        contactNumber,
        VSpacer(Dimension.SIZE_8),
        emergencyContact,
        emergencyContactInfo,
        VSpacer(Dimension.SIZE_22),
        minderProfileViewStack,
        spacing: Dimension.SIZE_12.cgFloat
    )
    
    
    override func setupViews() {
        self.addSubViews(scrollView,saveChangesButton)
        scrollView.addSubViews(containerStack,userProfileImage, addressFieldPressable)
    }
    
    override func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.topMargin).offset(Dimension.SIZE_22)
            make.bottom.equalTo(saveChangesButton.snp.topMargin)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
        userProfileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        saveChangesButton.snp.makeConstraints { make in
            make.left.equalTo(containerStack.snp.leftMargin)
            make.right.equalTo(containerStack.snp.rightMargin)
            make.bottom.equalToSuperview().offset(-Dimension.SIZE_22)
        }
        
        addressFieldPressable.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(addressField)
            make.right.equalTo(addressDeleteView.snp.left).offset(-10)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemCount : Float = 7.0
        let spacing : Float  = itemCount * Float(availableDaysLayout.minimumInteritemSpacing + availableDaysLayout.minimumLineSpacing)
        let width =  (Float(availableDaysCollection.frame.width) - spacing )  / itemCount
        
        availableDaysLayout.itemSize = .init(width: Int(width), height: 32)
        workingHoursLayout.itemSize = .init(width: workingHoursCollection.frame.width, height: 32)
        petBehaviourCollectionViewLayout.itemSize = .init(width: petBehaviourCollectionView.frame.width/2.2, height: 52)
    }
    
    static func LabelWithTrailingIcon(label:String,icon:UIImage) -> LabeWithTrailingIcon{
        let labelView = TextBody(label: label).apply { it in
            it.font = .bodyMedium.withSize(16)
            it.clipsToBounds = false
        }
        
        let iconView  = UIImageView(image: icon).apply { it in
            it.contentMode = .scaleAspectFit
            it.enableRipple(style: .unbounded)
            it.withSize(16)
        }
        
        return LabeWithTrailingIcon(
            label:labelView ,
            icon: iconView,
            container: hstack(labelView,iconView, UIView(), spacing : 10, alignment: .center)
        )
    }
    
    static func breedPreferenceItem(icon:String,label:String) -> UIView {
        return hstack(
            CheckBox().withSize(20).apply{ it in
                it.isUserInteractionEnabled = false
            },
            UIImageView(image: UIImage(named: icon)),
            TextBody(label: label),
            UIView(),
            spacing: Dimension.SIZE_16.cgFloat
        ).apply { it in
            it.enableRipple().rippleView.layer.cornerRadius = 4
            it.withMargins(.allSides(8))
        }
    }
}
