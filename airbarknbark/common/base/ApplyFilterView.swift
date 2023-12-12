//
//  MapFilterView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 29/12/2022.
//

import Foundation
import UIKit

class ApplyFilterView : BaseUIView{
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let searchButton = PrimaryButton(label: "Search Results").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "Filter"),
        UIView(),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    lazy var reasonsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomViewFlowLayout()
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(MinderFullProfileView.FlowLabelItemCell.self)
    }
    
    let reasonTextView = UITextView().withHeight(100).apply { it in
        it.font = .poppinsRegular(fontSize: 14)
        it.textColor = .onBackground
        it.text = "Write your own...."
    }
    
    lazy var reasonTextViewWrapper = reasonTextView.wrapInUIView { container, child in
        container.backgroundColor = UIColor(hexString: "#F4F4F4")
        child.backgroundColor = UIColor(hexString: "#F4F4F4")
        let textView = (child as! UITextView)
        textView.textContainer.maximumNumberOfLines = 4
        
        child.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    let withPetCheckbox = CheckBox().withSize(16)
    let withPetLabel = TextBody(label: "With Pet").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
    }
    
    lazy var withPetStack =  hstack(
        withPetCheckbox,
        withPetLabel,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    let withoutPetCheckbox = CheckBox().withSize(16)
    let withoutPetLabel = TextBody(label: "Without Pet").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
    }
    
    lazy var withoutPetStack =  hstack(
        withoutPetCheckbox,
        withoutPetLabel,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    lazy var findersPreferenceContainer =  OutlineLabelOn(label: "Finders Preference") { parent in
        parent.addSubViews(withPetStack,withoutPetStack)
        
        withPetStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-20)
        }
        withoutPetStack.snp.makeConstraints { make in
            make.left.equalTo(withPetStack.snp.right).offset(40)
            make.top.equalToSuperview().offset(15)
            
        }
    }
    
    let genderMaleCheckbox = CheckBox().withSize(16)
    let genderMaleLabel = TextBody(label: "Male").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
    }
    
    lazy var genderMaleStack =  hstack(
        genderMaleCheckbox,
        genderMaleLabel,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    let genderFemaleCheckbox = CheckBox().withSize(16)
    let genderFemaleLabel = TextBody(label: "Female").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
    }
    lazy var genderFemaleStack =  hstack(
        genderFemaleCheckbox,
        genderFemaleLabel,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    let genderOthersCheckbox = CheckBox().withSize(16)
    let genderOthersLabel = TextBody(label: "Others").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .left
    }
    lazy var genderOthersStack =  hstack(
        genderOthersCheckbox,
        genderOthersLabel,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    
    lazy var genderContainer =  OutlineLabelOn(label: "Gender") { parent in
        parent.addSubViews(genderMaleStack,genderFemaleStack,genderOthersStack)
        
        genderMaleStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        genderFemaleStack.snp.makeConstraints { make in
            make.left.equalTo(genderMaleStack.snp.right).offset(40)
            make.top.equalToSuperview().offset(20)
        }
        genderOthersStack.snp.makeConstraints { make in
            make.left.equalTo(genderFemaleStack.snp.right).offset(40)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    
    let distanceSlider = UISlider().apply { it in
        it.tintColor = .primary
        it.thumbTintColor = .primary
        it.minimumValue = 1
        it.maximumValue = Float(Config.mapFilterMaximumDistance)
    }
    
    let distanceLabel = TitleH3(label: "1 Km").apply { it in
        it.font = .poppinsBold(fontSize: 12)
    }
    lazy var distanceContainer = stack(
        TitleH3(label: "Maximum Distance"),
        VSpacer(Dimension.SIZE_16),
        distanceLabel,
        VSpacer(Dimension.SIZE_16),
        hstack(
            Caption(label: "Min"),
            HSpacer(Dimension.SIZE_8),
            distanceSlider,
            HSpacer(Dimension.SIZE_8),
            Caption(label: "Max")
        )
    )
    
    lazy var containerStack = stack(
        UIView(),
        titleHStack,
        VSpacer(Dimension.SIZE_22),
        findersPreferenceContainer,
        VSpacer(Dimension.SIZE_22),
        genderContainer,
        VSpacer(Dimension.SIZE_22),
        distanceContainer,
        VSpacer(Dimension.SIZE_22),
        searchButton,
        VSpacer(Dimension.SIZE_22),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    override func setupViews(){
        addSubview(containerStack)
    }
    
    override func setupConstraints(){
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
    }
}
