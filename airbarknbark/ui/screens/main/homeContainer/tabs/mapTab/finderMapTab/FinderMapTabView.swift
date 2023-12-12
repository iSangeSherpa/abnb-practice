//
//  HomeTabView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit
import MapKit

class FinderMapTabView : BaseUIView{
    
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
  
    lazy var legands = MapLegands()
    
    let bottomDialerButton = ButtonBox(icon: UIImage(named: "ic_dialer"))
    
    lazy var bottomStack = hstack(
        bottomDialerButton,
        PrimaryButton(label: "Message This Minder"),
        spacing: Dimension.SIZE_16.cgFloat,
        alignment: .center
    )
    
    let mapView  = MKMapView()
    
    
    let mapListItemLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var emptyNearbyUsers = Caption(label: "No users nearby").apply { it in
        it.isHidden = true
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
    
    lazy var usersLocationTrackingButton = MKUserTrackingButton(mapView: mapView)
    
    lazy var usersLocationTrackingButtonContainer = usersLocationTrackingButton
        .wrapInUIView { container, child in
            container.backgroundColor  = .surface
            container.layer.cornerRadius  = 2
            child.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    
    lazy var longPressLabel = Caption(label: "Long press on the map to choose your location")
    
    lazy var selectedLocationLabel = Caption(label: "")
    let doneLocationSelectionButton : UIButton = TextButton(label:"Done")
        .apply{ it in
            it.titleLabel?.font = .captionMedium.withSize(13)
        }
    
    lazy var selectedLocationContainer = hstack(UIView(),selectedLocationLabel,UIView(),doneLocationSelectionButton,HSpacer(Dimension.SIZE_4))
    
    lazy var bottomMessageContainer = stack(
        VSpacer(Dimension.SIZE_12),
        longPressLabel,
        selectedLocationContainer,
        VSpacer(Dimension.SIZE_12)
    ).withMargins(.horizontal(20)).apply { it in
        it.backgroundColor = .background
    }
    override func setupViews() {
        addSubViews(
            mapView,
            listView,
            topStack,
            locationSearchStack,
            emptyNearbyUsers,
            bottomMessageContainer,
            usersLocationTrackingButtonContainer,
            legands
        )
    }
    
    override func setupConstraints() {
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING )
            make.topMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING + 8)
        }
        bottomMessageContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.bottomMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING)
        }
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.topMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING + 8)
        }
        
        emptyNearbyUsers.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        usersLocationTrackingButtonContainer.snp.makeConstraints { make in
            make.right.equalTo(bottomMessageContainer)
            make.bottom.equalTo(bottomMessageContainer.snp.top).offset(-Dimension.SIZE_16)
        }
        
        legands.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Dimension.SIZE_16)
            make.bottom.equalTo(bottomMessageContainer.snp.top).offset(-Dimension.SIZE_16)
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


class LocationSearchItemCell : BaseUICollectionViewCell{
    
    let locationLabel = Caption(label: "",font:.poppinsMedium(fontSize: 12)).apply{ it in
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
        it.textAlignment = .left
    }
    
    lazy var itemContainer = hstack(
        HSpacer(Dimension.SIZE_8),
        UIImageView(icon: "ic_location", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
        HSpacer(Dimension.SIZE_8),
        locationLabel,
        HSpacer(Dimension.SIZE_8)
    )
        
    
    override func setupViews() {
        addSubViews(itemContainer)
    }
    
    override func setupConstraints() {
        itemContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    func configure(model:Address){
        locationLabel.text = model.name
        itemContainer.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
}
