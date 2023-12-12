//
//  MinderMapTabView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import UIKit
import MapKit

class MinderMapTabView : BaseUIView{
    lazy var activeProfileToggleView = ActiveProfileToggleView()
    
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
    
    let searchIcon = UIImageView( image: UIImage(named: "ic_search")?.withTintColor(.onBackground)).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple(style:.unbounded, factor:1.5)
        it.isUserInteractionEnabled  = true
    }
    
    let filterIcon = UIImageView( image: UIImage(named: "ic_filter")).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple(style:.unbounded, factor:1.5)
        it.isUserInteractionEnabled  = true
    }
    
    let viewModeIcon = UIImageView( image: UIImage(named: "ic_listview")).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple(style:.unbounded,factor:1.5)
        it.isUserInteractionEnabled  = true
    }
    

    lazy var topStack = hstack(
        activeProfileToggleView,
        UIView(),
        searchIcon.withSize(18),
        HSpacer(1),
        filterIcon.withSize(18),
        HSpacer(1),
        viewModeIcon.withSize(18),
        spacing: Dimension.SIZE_8.cgFloat,
        alignment: .center
    ).withHeight(40)
    
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
    
    let mapView  = MKMapView()

    lazy var legands = MapLegands()
    
    lazy var usersLocationTrackingButton = MKUserTrackingButton(mapView: mapView)
    
    lazy var usersLocationTrackingButtonContainer = usersLocationTrackingButton
        .wrapInUIView { container, child in
            container.backgroundColor  = .surface
            container.layer.cornerRadius  = 2
            child.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    
    
    let bottomDialerButton = ButtonBox(icon: UIImage(named: "ic_dialer"))
    
    lazy var bottomStack = hstack(
        bottomDialerButton,
        PrimaryButton(label: "Message This Minder"),
        spacing: Dimension.SIZE_16.cgFloat,
        alignment: .center
    ).apply({ it in
        it.isHidden = true
    })
    
    
    
    let mapListItemLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var mapListItemCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: mapListItemLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(MapListItemCell.self)
    }
    
    lazy var listView  = stack(
        TitleH3(label: "List View"),
        mapListItemCollection,
        spacing: Dimension.SIZE_22.cgFloat
    )
    
    override func setupViews() {
        addSubViews(mapView,listView,topStack,locationSearchStack, usersLocationTrackingButtonContainer,legands)
    }
    
    override func setupConstraints() {
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING )
            make.topMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING + 8)
        }

        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.topMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING + 8)
        }
        
        usersLocationTrackingButtonContainer.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Dimension.SIZE_16)
            make.bottom.equalTo(mapView.snp.bottom).offset(-Dimension.SIZE_16)
            make.right.equalToSuperview()
        }
        
        legands.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Dimension.SIZE_16)
            make.bottom.equalTo(usersLocationTrackingButton.snp.bottom)
        }
        locationSearchStack.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.top)
            make.left.equalTo(topStack.snp.left)
            make.width.equalTo(topStack.snp.width).inset(18*2 + 8)
        }
        
        locationSearchCollection.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }
    
    override func layoutSubviews() {
        mapListItemLayout.itemSize = .init(width: Int(Float(mapListItemCollection.frame.width)), height: 180)
        locationSearchLayout.itemSize = .init(width: Int(Float(locationSearchCollection.frame.width)), height: 30)
    }
    
    
}
