//
//  HomeTabViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import MapKit
import SDWebImage

class FinderMapTabViewController : ViewController<FinderMapTabView, FinderMapTabViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    
    override func setupView() {
        
        binding.activeProfileToggleView.addOnItemClickListener{ activeProfile in
            self.binding.activeProfileToggleView.activeProfile = self.viewModel.activeProfile.value
            switch(activeProfile){
            case .FINDER:
                self.viewModel.setActiveProfile(activeProfile: .FINDER)
                break
            case .MINDER:
                fallthrough
            case .BOTH:
                guard let user = SessionManager.shared.user else{
                    return
                }
                if(user.minderProfile?.completionStatus == .COMPLETED){
                    self.viewModel.setActiveProfile(activeProfile: activeProfile)
                    return
                }
                MinderProfileSetupScreenViewController().apply { [self] it in
                    it.viewModel.fromProfile = true
                    it.viewModel.forIncompleteProfile = true
                    self.present(it, animated: true)
                }.result().bind{ _ in
                    self.viewModel.setActiveProfile(activeProfile: activeProfile)
                }.disposed(by: self.disposeBag)
            }
        }
        
        viewModel.activeProfile.bind(to: binding.activeProfileToggleView.rx.activeProfile).disposed(by: disposeBag)
        
        binding.viewModeIcon.rx.tapGesture().when(.recognized)
            .withLatestFrom(viewModel.viewMode) { _ , mode in
                mode == .List ? MapViewMode.Map : .List
            }.bind{
                self.viewModel.viewMode.accept($0)
                self.viewModel.locationSelectionMode.accept(false)
            }
            .disposed(by: disposeBag)
        
        viewModel.viewMode.map{
            $0 != .List
        }.bind(to: binding.listView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.viewMode.map{
            $0 != .Map
        }.bind(to: binding.mapView.rx.isHidden, binding.bottomMessageContainer.rx.isHidden , binding.usersLocationTrackingButton.superview!.rx.isHidden,
               binding.activeProfileToggleView.rx.isHidden,
               binding.legands.rx.isHidden
        )
            .disposed(by: disposeBag)
        
        
        
        viewModel.viewMode.map{
            UIImage(named: $0 == .Map ? "ic_listview" : "ic_location")?.withTintColor(.onBackground)
        }.bind(to: binding.viewModeIcon.rx.image)
            .disposed(by: disposeBag)
        
        binding.filterIcon.rx.tapGesture().when(.recognized).flatMap { _ in
            ApplyFilterViewController().apply { it in
                it.viewModel.setFilterParams(filterParams: self.viewModel.filterParams.value)
                self.present(it, animated: true)
            }.result()
        }.bind { [self] filterParams in
            viewModel.locationSelectionMode.accept(false)
            self.viewModel.searchMinders(filterParams: filterParams)
        }.disposed(by: disposeBag)
        
      
        viewModel.location.bind{
            guard let location = $0 else {return}
            let adjustedRegion = self.binding.mapView.regionThatFits(
                MKCoordinateRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(location.latitude), CLLocationDegrees(location.longitude)),latitudinalMeters: 20000,longitudinalMeters: 20000))
                self.binding.mapView.setRegion(adjustedRegion, animated: true)
            
            let annotation = UserAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude),
                                                   longitude: CLLocationDegrees(location.longitude)),
                name: "",
                distance: "",
                imageURL: SessionManager.shared.user?.image ?? "",
                ownLocation: true,
                activeProfile: SessionManager.shared.userType!,
                isProfileVerified: false,
                hasMinderProfile: false
            )
            
           
            self.binding.mapView.annotations.forEach { it in
                if let annotation = it as? UserAnnotation{
                    if(annotation.ownLocation){
                        self.binding.mapView.removeAnnotation(annotation)
                    }
                }
            }
            
            self.binding.mapView.addAnnotation(annotation)
            
            
        }.disposed(by: disposeBag)
    
        self.viewModel.onConversationStart.bind{
            [weak self] conversationId in
            ChatDetailsViewController().forConversationId(conversationId: conversationId).apply({ it in
                self?.parentController?.navigationController?.pushViewController(it,animated: true)
            })
        }.disposed(by: disposeBag)
        
        viewModel.locationSelectionMode.map{!$0}.bind(to: binding.selectedLocationContainer.rx.isHidden).disposed(by: disposeBag)
        viewModel.locationSelectionMode.map{$0}.bind(to: binding.longPressLabel.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.location.bind{
            guard let locationDetail = $0 else {return}
            let location = CLLocation(latitude: CLLocationDegrees(locationDetail.latitude), longitude: CLLocationDegrees(locationDetail.longitude))
            LocationService.shared.getPlaceName(location: location){
                self.binding.selectedLocationLabel.text = "\($0), (\(locationDetail.latitude),\(locationDetail.longitude))"
            }
            
//            if(SessionManager.shared.user?.address == nil){
//                ShowFillAddressViewController().apply { it in
//                    self.present(it, animated: true)
//                }
//            }
        }.disposed(by: disposeBag)
 
        binding.mapView.rx.longPressGesture().when(.began).map{
            let touchLocation = $0.location(in: self.binding.mapView)
            let locationCoordinate = self.binding.mapView.convert(touchLocation, toCoordinateFrom: self.binding.mapView)
            return LocationDetails(latitude: Float(locationCoordinate.latitude), longitude: Float(locationCoordinate.longitude))
        }.bind{ [weak self] locationDetails in 
            self?.updateMapLocation(locationDetails: locationDetails)
        }.disposed(by: disposeBag)
        
        binding.doneLocationSelectionButton.rx.tapGesture().when(.recognized).map{ _ in
            false
        }.bind(to: viewModel.locationSelectionMode).disposed(by: disposeBag)
        
        
        bindMapListItems()
        
        bindNearbyUsers()
        
        bindLocationSearchResults()
        
//        LocationService.shared.getLocation()
    }
    
    func bindLocationSearchResults(){
        
        binding.searchIcon.rx.tapGesture().when(.recognized).bind { _ in
            self.viewModel.showSearchLocation.accept(true)
        }.disposed(by: disposeBag)
        
        binding.mapView.rx.touchDownGesture().when(.recognized).bind{_ in
            self.viewModel.showSearchLocation.accept(false)
        }.disposed(by: disposeBag)
        
        viewModel.showSearchLocation.bind{
            self.binding.locationSearchStack.isHidden = !$0
            self.binding.activeProfileToggleView.isHidden = $0
            self.binding.searchIcon.isHidden = $0
        }.disposed(by: disposeBag)
        
        self.binding.locationSearchTextField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance).bind{
                searchLocation(query: $0){
                    self.viewModel.locationSearchResult.accept($0)
                }
            }.disposed(by: disposeBag)
        
        viewModel.locationSearchResult
            .bind(to: binding.locationSearchCollection.rx.items(cellIdentifier: LocationSearchItemCell.Identifier)){
                (row, item, cell)  in
                let cell = cell as! LocationSearchItemCell
                cell.configure(model:item)
                
                cell.rx.tapGesture().when(.recognized).bind{[weak self] _ in
                    self?.updateMapLocation(locationDetails: LocationDetails(latitude: Float(item.lat), longitude: Float(item.lang)))
                }.disposed(by: cell.disposeBag)
               
            }.disposed(by: disposeBag)
        
        viewModel.locationSearchResult.delay(.milliseconds(100), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.1) { [unowned self] in
                binding.locationSearchCollection.snp.updateConstraints{ make in
                    make.height.equalTo(min(180,binding.locationSearchCollection.contentSize.height))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }
                                           
    private func updateMapLocation(locationDetails: LocationDetails){
        self.viewModel.updateUsersLocation(locationDetails: locationDetails)
        self.viewModel.showSearchLocation.accept(false)
        self.viewModel.location.accept(locationDetails)
    }

    func moveMapView(userAnnotation : UserAnnotation){
        
        let pinLocation = userAnnotation.coordinate

        let currentCoordinates = binding.mapView.centerCoordinate
        
        binding.mapView.centerCoordinate = pinLocation
        
        let viewCenter = self.view.center
        let fakecenter = CGPoint(x: viewCenter.x, y: viewCenter.y - 20)
        let coordinate: CLLocationCoordinate2D = binding.mapView.convert(fakecenter, toCoordinateFrom: self.view)

        self.binding.mapView.centerCoordinate = currentCoordinates
        self.binding.mapView.setCenter(coordinate, animated: true)
    }
    
    private func bindMapListItems(){
        viewModel.mapListItems
            .bind(to: binding.mapListItemCollection.rx.items(cellIdentifier: MapListItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MapListItemCell
                cell.configure(model:item)
                
                if(!item.hasMinderProfile){
                    cell.createRequestButton.setTitle("View Profile", for: .normal)
                    cell.createRequestButton.rx.tapGesture().when(.recognized)
                        .bind{_ in
                            FinderProfileViewController().apply { it in
                                guard let userId = item.address?.userId else {return}
                                it.viewModel.finderUserId = userId
                                self.parentController?.navigationController?.pushViewController(it, animated: true)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                }else{
                    cell.createRequestButton.setTitle("+  Create Request", for: .normal)
                    cell.createRequestButton.rx.tapGesture().when(.recognized)
                        .bind{_ in
                            MinderFullProfileViewController().apply { it in
                                guard let minderUserId = item.address?.userId else {return}
                                it.viewModel.minderUserId = minderUserId
                                self.parentController?.navigationController?.pushViewController(it, animated: true)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                }
               
                if(item.showMyNumber ?? false){
                    cell.dialerBtton.isUserInteractionEnabled = true
                    cell.dialerBtton.addOnClickListner {
                        Utils.dialNumber(number: item.phone)
                    }
                }else{
                    cell.dialerBtton.isUserInteractionEnabled = false
                }

                cell.mailButton.addOnClickListner {[unowned self] in
                    self.viewModel.startConversation(receiverUserId: item.id)
                }
                
            }.disposed(by: disposeBag)
        
        
        viewModel.viewMode.bind{
            if($0 == .List){
                self.binding.emptyNearbyUsers.isHidden = !self.viewModel.mapListItems.value.isEmpty
            }else{
                self.binding.emptyNearbyUsers.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        viewModel.mapListItems.map{(!$0.isEmpty || (self.viewModel.viewMode.value == MapViewMode.Map))}.bind(to: binding.emptyNearbyUsers.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func bindNearbyUsers(){
        
        binding.mapView.delegate = self
        
        viewModel.nearByUsers.bind{
            let userAnnotations =  self.binding.mapView.annotations.filter{$0.isKind(of: UserAnnotation.self)}.map{$0 as! UserAnnotation}.filter{!$0.ownLocation}
            self.binding.mapView.removeAnnotations(userAnnotations)
            self.binding.mapView.addAnnotations($0)
            
        }.disposed(by: disposeBag)
    }
        
    func showJoiningTypeDialog() -> Maybe<ActiveProfile>{
        return .create{ [self] maybe in
            let viewController = DialogViewController<JoiningAsDialogView,ViewModel>().setupBy { dialog in
                dialog.binding.crossButton.addOnClickListner {
                    maybe(.completed)
                }
                dialog.binding.cancelButton.addOnClickListner {
                    maybe(.completed)
                }
                dialog.binding.optionMinder.addOnClickListner {
                    maybe(.success(.MINDER))
                }
                dialog.binding.optionFinder.addOnClickListner {
                    maybe(.success(.FINDER))
                }
                dialog.binding.optionBoth.addOnClickListner {
                    maybe(.success(.BOTH))
                }
            }
            present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }
    }
        
}

extension FinderMapTabViewController : MKMapViewDelegate, UIPopoverPresentationControllerDelegate{
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
           return .none
       }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {return nil}
        let annotation = annotation as! UserAnnotation
        
        var view: UserAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: UserAnnotationView.identifier) as? UserAnnotationView
        if view == nil {
            view = UserAnnotationView(annotation: annotation, reuseIdentifier: UserAnnotationView.identifier)
           
        }
       
        if(annotation.ownLocation){
            view?.render(imageSize:90)
        }else{
            view?.render()
            view?.currentLocationView.isHidden = true
        }
        view?.imageView.layer.borderColor = annotation.activeProfile.getColor().cgColor
        view?.imageView.loadImage(src: annotation.imageURL,type: .User)
        view?.annotation = annotation
       
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let userAnnotation = view.annotation as? UserAnnotation else {return}

        self.moveMapView(userAnnotation: userAnnotation)
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        if(userAnnotation.ownLocation){
            return
        }
        
        PopoverUserCalloutViewController().apply { it in
            it.modalPresentationStyle = .popover
            it.popoverPresentationController?.sourceView = view
            it.popoverPresentationController?.permittedArrowDirections = .down
            it.popoverPresentationController?.delegate = self
            it.descriptionStack.addOnClickListner {[unowned self] in
                it.dismiss(animated: true)
                MinderFullProfileViewController().apply {[unowned self] in
                    $0.viewModel.minderUserId = userAnnotation.id
                    self.navigationController?.pushViewController($0, animated: true)
                }
            }
            
            it.imageView.addOnClickListner{[unowned self] in
                it.dismiss(animated: true)
                if(userAnnotation.hasMinderProfile){
                    MinderFullProfileViewController().apply {[unowned self] in
                        $0.viewModel.minderUserId = userAnnotation.id
                        self.parentController?.navigationController?.pushViewController($0, animated: true)
                    }
                }else{
                    FinderProfileViewController().apply {[unowned self] in
                        $0.viewModel.finderUserId = userAnnotation.id
                        self.parentController?.navigationController?.pushViewController($0, animated: true)
                    }
                }
            }
            
            it.messageButton.addOnClickListner{[unowned self] in
                it.dismiss(animated: true)
                if(userAnnotation.hasMinderProfile){
                    MinderFullProfileViewController().apply {
                        $0.viewModel.minderUserId = userAnnotation.id
                        self.parentController?.navigationController?.pushViewController($0, animated: true)
                    }
                }else{
                    FinderProfileViewController().apply {
                        $0.viewModel.finderUserId = userAnnotation.id
                        self.parentController?.navigationController?.pushViewController($0, animated: true)
                    }
                }
            }
            
            
            
            let selectedItem = self.viewModel.mapListItems.value.filter{
                $0.id == userAnnotation.id
            }.first
            
            if(selectedItem?.showMyNumber ?? false){
                it.dialerButton.isUserInteractionEnabled = true
                it.dialerButton.addOnClickListner{
                    it.dismiss(animated: true)
                    Utils.dialNumber(number: selectedItem?.phone ?? "")
                }
            }else{
                it.dialerButton.isUserInteractionEnabled = false
            }
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.6){
                self.present(it, animated: true, completion: nil)
                it.configure(annotation : userAnnotation)
            }
        }
    }
}
