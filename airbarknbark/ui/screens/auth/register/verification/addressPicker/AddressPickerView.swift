//
//  AddressPickerView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 23/11/2022.
//

import Foundation
import UIKit
import MapKit

class AddressPickerView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let locationSearchTextField = UITextField().apply { it in
        it.font = .poppinsRegular(fontSize: 14)
        it.textColor = .onBackground
        it.placeholder = .MapTab.searchLocation
        it.leftView = hstack(
            HSpacer(10),
            UIImageView( image: UIImage(named: "ic_search")?.withTintColor(.onBackground)).withSize(16),
            HSpacer(10)
        )
        it.leftViewMode = .always
    }.withHeight(40)
    
    let locationSearchLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }

    lazy var locationSearchCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: locationSearchLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(LocationSearchItemCell.self)
    }
        
    lazy var locationSearchStack = stack(
        locationSearchTextField,
        VDivider(),
        locationSearchCollection
    ).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 8
        it.backgroundColor = .surface
        it.clipsToBounds = true
    }
    
    let mapView  = MKMapView().apply { it in
        it.showsUserLocation = true
    }
    
    
    lazy var selectedLocationLabel = Caption(label: "Tap on the map to choose your location").apply { it in
        it.textAlignment = .left
    }
    
    let doneLocationSelectionButton : UIButton = TextButton(label:"Done")
        .apply{ it in
            it.titleLabel?.font = .captionMedium.withSize(13)
        }
    
    lazy var selectedLocationContainer = hstack(selectedLocationLabel,UIView(),doneLocationSelectionButton,HSpacer(Dimension.SIZE_4)).apply { it in
        it.backgroundColor = .background
    }
    
    lazy var usersLocationTrackingButton = MKUserTrackingButton(mapView: mapView)
    
    lazy var usersLocationTrackingButtonContainer = usersLocationTrackingButton
        .wrapInUIView { container, child in
            container.backgroundColor  = .surface
            container.layer.cornerRadius  = 2
            child.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    
    
    lazy var bottomMessageContainer = stack(
        VSpacer(Dimension.SIZE_12),
        selectedLocationContainer,
        VSpacer(Dimension.SIZE_12)
    ).withMargins(.horizontal(20)).apply { it in
        it.backgroundColor = .background
    }
    
    override func setupViews() {
        addSubViews(mapView,backButton,bottomMessageContainer, locationSearchStack)
        addSubview(usersLocationTrackingButtonContainer)
    }
    
    override func layoutSubviews() {
        locationSearchLayout.itemSize = .init(width: Int(Float(locationSearchCollection.frame.width)), height: 30)
    }
    
    override func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Dimension.SCREEN_PADDING )
            make.topMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING + 8)
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomMessageContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.bottomMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING)
        }
        
        usersLocationTrackingButtonContainer.snp.makeConstraints { make in
            make.right.equalTo(bottomMessageContainer)
            make.bottom.equalTo(bottomMessageContainer.snp.top).offset(-Dimension.SIZE_16)
        }
        
        locationSearchStack.snp.makeConstraints { make in
            make.top.equalTo(backButton).offset(-4)
            make.left.equalTo(backButton.snp.right).offset(Dimension.SIZE_8)
            make.right.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        locationSearchCollection.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }
}
