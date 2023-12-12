//
//  CreateRequestView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit

class CreateRequestView : BaseUIView {
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
    
    let title = TitleH2(label:  .MinderFullProfile.createRequest)
    
    let fromDateValue = UITextField().apply { it in
        it.font = .poppinsRegular(fontSize: 12)
        it.textAlignment = .center
        it.placeholder = "D/M/Y"
    }
    
    lazy var fromDatePicker   = fromDateValue.asDatePickerField{
        $0.pickerView.datePickerMode = .date
    }
    
    let toDateValue = UITextField().apply { it in
        it.font = .poppinsRegular(fontSize: 12)
        it.textAlignment = .center
        it.placeholder = "D/M/Y"
    }
    
    lazy var toDatePicker = toDateValue.asDatePickerField{
        $0.pickerView.datePickerMode = .date
    }
    
    let fromTimeValue = UITextField().apply { it in
        it.font = .poppinsRegular(fontSize: 12)
        it.textAlignment = .center
        it.placeholder = "00:00"
    }
    
    
    let toTimeValue = UITextField().apply { it in
        it.font = .poppinsRegular(fontSize: 12)
        it.textAlignment = .center
        it.placeholder = "00:00"
    }
    

    lazy var dateContainerStack = hstack(
        Caption(label: "Date").apply { it in
            it.font = .poppinsRegular(fontSize: 12)
            it.textAlignment = .center
        }.withWidth(35),
        HSpacer(1).apply({ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        }),
        HSpacer(Dimension.SIZE_2),
        Caption(label: "From:").apply { it in
            it.font = .poppinsRegular(fontSize: 12)
            it.textAlignment = .center
            it.textColor = .onBackground.withAlphaComponent(0.6)
        }.withWidth(35),
        fromDateValue.withWidth(75),
        HSpacer(Dimension.SIZE_2),
        UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
            it.contentMode = .scaleAspectFit
        }.withWidth(Dimension.SIZE_8.cgFloat),
        UIView(),
        Caption(label: "To:").apply { it in
            it.font = .poppinsRegular(fontSize: 12)
            it.textAlignment = .center
            it.textColor = .onBackground.withAlphaComponent(0.6)
        }.withWidth(20),
        toDateValue.withWidth(75),
        HSpacer(Dimension.SIZE_2),
        UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
            it.contentMode = .scaleAspectFit
        }.withWidth(Dimension.SIZE_8.cgFloat),
        HSpacer(Dimension.SIZE_4),
        spacing: Dimension.SIZE_4.cgFloat
    )
    
    lazy var timeContainerStack = hstack(
        Caption(label: "Time").apply { it in
            it.font = .poppinsRegular(fontSize: 12)
            it.textAlignment = .center
        }.withWidth(35),
        HSpacer(1).apply({ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        }),
        HSpacer(Dimension.SIZE_2),
        Caption(label: "From:").apply { it in
            it.font = .poppinsRegular(fontSize: 12)
            it.textAlignment = .center
            it.textColor = .onBackground.withAlphaComponent(0.6)
        }.withWidth(35),
        fromTimeValue.withWidth(70),
        HSpacer(Dimension.SIZE_2),
        UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
            it.contentMode = .scaleAspectFit
        }.withWidth(Dimension.SIZE_8.cgFloat),
        UIView(),
        Caption(label: "To:").apply { it in
            it.font = .poppinsRegular(fontSize: 12)
            it.textAlignment = .center
            it.textColor = .onBackground.withAlphaComponent(0.6)
        }.withWidth(20),
        toTimeValue.withWidth(70),
        HSpacer(Dimension.SIZE_2),
        UIImageView(image:UIImage(named: "ic_drop_down")).apply { it in
            it.contentMode = .scaleAspectFit
        }.withWidth(Dimension.SIZE_8.cgFloat),
        HSpacer(Dimension.SIZE_4),
        spacing: Dimension.SIZE_4.cgFloat
    )
    lazy var dateTimeContainerStack = stack(
        UIView(),
        dateContainerStack,
        UIView(),
        timeContainerStack,
        UIView(),
        distribution: .equalCentering)
    
    lazy var dateTimeContainer =  OutlineLabelOn(label: .MinderFullProfile.selectDateTime) { parent in
        
        parent.addSubViews(dateTimeContainerStack)
        
        parent.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
    }.apply { it in
        dateTimeContainerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    let petsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var petsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: petsLayout
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(SelectedPetItemCell.self)
    }
    
    lazy var petsContainer =  OutlineLabelOn(label: .MinderFullProfile.selectPets) { parent in
        
        parent.addSubViews(petsCollection)
        
        parent.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
    }.apply { it in
        petsCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    lazy var perHourRateInfo = InfoView(.MinderFullProfile.serviceChargeInfo)
    
    let perHourRateInputField = OutlineInputField(label: "Per hour rate").apply { it in
        it.keyboardType = .decimalPad
    }
    
    let additionalNotesInputField = OutlineInputArea(hint: .MinderFullProfile.additionalNotes).apply { it in
        it.preferredContainerHeight = 150
    }
    
    
    let sendRequestButton  = PrimaryButton(label: .MinderFullProfile.sendRequest)
    
    lazy var containerStack = stack(
        backButtonWrapper,
        title,
        VSpacer(Dimension.SIZE_8),
        dateTimeContainer,
        VSpacer(Dimension.SIZE_8),
        petsContainer,
        VSpacer(Dimension.SIZE_8),
        perHourRateInfo,
        perHourRateInputField,
        VSpacer(Dimension.SIZE_8),
        additionalNotesInputField,
        VSpacer(Dimension.SIZE_8),
        stack(sendRequestButton,VSpacer(Dimension.SIZE_4), Caption(label: .MinderFullProfile.bottomNote)),
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
    
    override func layoutSubviews() {
        petsLayout.itemSize = .init(width: 80 , height: Int(Float(petsCollection.frame.height)))
    }
    
}

