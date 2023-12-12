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
import SnapKit

class MinderProfileSetupScreenView : BaseUIView{
    
    let backButton = BackButton()
    
    let rightIcon = UIImageView(image:UIImage(named: "ic_person")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let scrollView  = UIScrollView().apply { it in
        it.keyboardDismissMode = .interactive
    }
    

    let title = TitleH2(label: .MinderProfileSetup.profileSetup)
    
    let availabilityLabel = Caption(label: .MinderProfileSetup.availability,font: .poppinsMedium(fontSize: 16))

    lazy var availabilityInfo = InfoView(.MinderProfileSetup.availabilityInfo,false)
    
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
    
    let ratesLabel = Caption(label: .MinderProfileSetup.rates,font: .poppinsMedium(fontSize: 16))
    
    let rateField  = OutlineInputField(label: .MinderProfileSetup.payPerService, hint: "").apply { it in
        it.keyboardType = .decimalPad
        it.addLeadingView(view: Caption(label: "$").apply{ it in
            it.textColor = .onBackground.withAlphaComponent(0.6)
        })
        
        it.addTrailingView(view: Caption(label: .MinderProfileSetup.perHour).apply{ it in
            it.textColor = .onBackground.withAlphaComponent(0.6)
        })
    }
    
    let experienceLabel = Caption(label: .MinderProfileSetup.experience,font: .poppinsMedium(fontSize: 16))
    
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
    
    let termsCheckBox = CheckBox().withSize(20)
    
    let termsText = UITextView().apply() {
        
        let attributedString = NSMutableAttributedString(string: .Register.termsCaption)
        let url = URL(string: .Register.termsLink)!
//        attributedString.setAttributes([.link: url, .font : UIFont.poppinsSemibold(fontSize: 13), .foregroundColor : UIColor.primary], range: NSMakeRange(String.Register.termsCaption.count-21, 21))
        $0.linkTextAttributes = [.foregroundColor: UIColor.primary]
        $0.textAlignment = .center
        $0.font = .poppinsLight(fontSize: 13)
        $0.isEditable = false
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.isScrollEnabled = false
        $0.attributedText = attributedString
        $0.isUserInteractionEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        $0.sizeToFit()
          
    }
        
    
    let continueButton  = PrimaryButton(label: .MinderProfileSetup.done)
    
    lazy var topStack =  stack(
        hstack(
            backButton,
            UIView()
        ).withMargins(.init(top: 0, left: -Dimension.SIZE_8.cgFloat, bottom: 0, right: 0)),
        hstack(
            title,
            UIView(),
            rightIcon.withSize(26)
        ),
        VSpacer(Dimension.SIZE_8),
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    lazy var bottomStack = stack(
        VSpacer(Dimension.SIZE_4),
        hstack(
            termsCheckBox,
            termsText,
            spacing: Dimension.SIZE_8.cgFloat,
            alignment: .center
        ),
        continueButton,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    lazy var containerStack = stack(
        hstack(availabilityLabel,UIView()),
//        availabilityInfo,
        VSpacer(Dimension.SIZE_4),
        availableContainer,
//        VSpacer(Dimension.SIZE_8),
        availableDaysContainer,
//        VSpacer(Dimension.SIZE_22),
        workingHoursContainer,
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
    
    override func setupViews() {
        addSubViews(
            topStack,
            scrollView,
            bottomStack
        )
        scrollView.addSubview(containerStack)
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
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(topStack.snp.bottom)
            make.bottom.equalTo(bottomStack.snp.top)
        }
        
        bottomStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SIZE_16)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
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

struct LabeWithTrailingIcon{
    var label:UILabel
    var icon:UIView
    var container:UIView
}

class AvailableDayCell : BaseUICollectionViewCell{
    
    let label = Caption(label: "").apply { it in
        it.font = .captionTinyMedium
        it.numberOfLines = 0
        it.textAlignment = .center
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 2
    }
    
    override func setupViews() {
        addSubViews(label)
    }
    
    override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class WorkingHourCell : BaseUICollectionViewCell{
    
    let label = Caption(label: "").apply { it in
        it.font = .captionMedium
        it.numberOfLines = 0
        it.textAlignment = .center
    }
    
    
    let fromLabel = Caption(label: "From:").apply { it in
        it.font = .bodyMedium
        it.numberOfLines = 0
        it.textAlignment = .center
        it.textColor = .onBackground.withAlphaComponent(0.6)
    }
    
    let fromValue = UITextField().apply { it in
        it.font = .bodyMedium
        it.textAlignment = .center
    }
    
    lazy var fromPicker   = fromValue.asDatePickerField{
        $0.pickerView.datePickerMode = .time
    }
    
    
    let fromDropDownIcon = UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let toLabel = Caption(label: "To:").apply { it in
        it.font = .bodyMedium
        it.numberOfLines = 0
        it.textAlignment = .center
        it.textColor = .onBackground.withAlphaComponent(0.6)
    }
    
    let toValue = UITextField().apply { it in
        it.font = .bodyMedium
        it.textAlignment = .center
    }
    
    lazy var toPicker = toValue.asDatePickerField{
        $0.pickerView.datePickerMode = .time
    }
    
    let toDropDownIcon = UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    lazy var stack = hstack(
        label.withWidth(40),
        HSpacer(1).apply({ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        }),
        HSpacer(Dimension.SIZE_2),
        fromLabel.withWidth(50),
        fromValue.withWidth(70),
        HSpacer(Dimension.SIZE_2),
        fromDropDownIcon.withWidth(Dimension.SIZE_8.cgFloat),
        UIView(),
        toLabel.withWidth(30),
        toValue.withWidth(70),
        HSpacer(Dimension.SIZE_2),
        toDropDownIcon.withWidth(Dimension.SIZE_8.cgFloat),
        HSpacer(Dimension.SIZE_4),
        spacing: Dimension.SIZE_4.cgFloat
    )
    
    override func setupViews() {
        addSubViews(stack)
    }
    
    override func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(0)
        }
    }
}

class PetBehaviourCell : BaseUICollectionViewCell{
    
    let checkBox = CheckBox().withSize(16).apply{ it in
        it.isUserInteractionEnabled = false
    }
    
    let label = TextBody(label: "", font: .poppinsRegular(fontSize: 12)).apply { it in
        it.numberOfLines = 2
        it.textAlignment = .left
    }
    
    lazy var stack =  hstack(
        checkBox,
        label,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    override func setupViews() {
        addSubViews(stack)
        stack.withMargins(.allSides(Dimension.SIZE_8.cgFloat))
        stack.enableRipple().rippleView.layer.cornerRadius = 4
    }
    
    override func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
