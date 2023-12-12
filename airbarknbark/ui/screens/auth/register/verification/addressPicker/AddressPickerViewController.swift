//
//  AddressPickerViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 23/11/2022.
//

import Foundation
import RxSwift
import MapKit

class AddressPickerViewController : ViewController<AddressPickerView,AddressPickerViewModel>, MKMapViewDelegate{
    let geoCoder = CLGeocoder()
    
    override func setupView() {
        self.isModalInPresentation  = true
        
        binding.mapView.delegate  = self
        
        binding.backButton.rx.tap
            .map { it in
                return Void()
            }
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        viewModel.address.map{($0 == nil)}.bind(to: binding.doneLocationSelectionButton.rx.isHidden).disposed(by: disposeBag)
        
        binding.mapView.rx.tapGesture().when(.ended).map{
            let touchLocation = $0.location(in: self.binding.mapView)
            let locationCoordinate = self.binding.mapView.convert(touchLocation, toCoordinateFrom: self.binding.mapView)
            return locationCoordinate
        }.bind{locationCoordinate in
            LocationService.shared.getPlaceName(location: CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)){
                self.viewModel.address.accept(Address(lat: Double(locationCoordinate.latitude), lang: Double(locationCoordinate.longitude), name:$0))
            }
        }.disposed(by: disposeBag)
        
        binding.doneLocationSelectionButton.rx.tapGesture().when(.recognized).bind{ _ in
            guard let address = self.viewModel.address.value else {return}
            self.viewModel.onAddressSelected.accept(address)
        }.disposed(by: disposeBag)
        
        viewModel.address.bind{
            guard let address = $0 else {return}
            self.binding.selectedLocationLabel.text = "\(address.name), (\(String(format: "%.2f",address.lat)),\(String(format: "%.2f",address.lang)))"
            self.binding.mapView.removeAnnotations(self.binding.mapView.annotations)
            let selectedLocationAnnotaion = MKPointAnnotation()
            selectedLocationAnnotaion.title = address.name
            selectedLocationAnnotaion.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(address.lat),
                                                                          longitude: CLLocationDegrees(address.lang))
            self.binding.mapView.addAnnotation(selectedLocationAnnotaion)
        }.disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){ [weak self] in
            self?.binding.mapView.setUserTrackingMode(.follow, animated: true)
        }
        
        bindLocationSearchResults()
    }
    
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if(mode != .none){
            if let userAddress = binding.mapView.userLocation.location {
                LocationService.shared.getPlaceName(location: userAddress){
                    let latitude = userAddress.coordinate.latitude
                    let longitude = userAddress.coordinate.longitude
                    self.viewModel.address.accept(Address(lat: Double(latitude), lang: Double(longitude), name:$0))
                }
            }
        }
    }
    
    
    func bindLocationSearchResults(){
        
        self.binding.locationSearchTextField.rx.text.orEmpty
            .distinctUntilChanged()
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
                
                cell.rx.tapGesture().when(.recognized).bind{ _ in
                    self.viewModel.address.accept(Address(lat: Double(item.lat), lang: Double(item.lang), name:item.name))
                    self.viewModel.locationSearchResult.accept([])
                    self.binding.locationSearchTextField.text = ""
                    self.binding.mapView.camera.centerCoordinate = .init(latitude: item.lat, longitude: item.lang)
                }.disposed(by: cell.disposeBag)
               
            }.disposed(by: disposeBag)
        
        viewModel.locationSearchResult
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.1) { [unowned self] in
                binding.locationSearchCollection.snp.updateConstraints{ make in
                    make.height.equalTo(min(180,binding.locationSearchCollection.contentSize.height))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }
    
    func result() -> Observable<Address>{
        return viewModel.onAddressSelected.asObservable()
    }
}
