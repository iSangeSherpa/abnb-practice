//
//  MinderMapTabViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import RxRelay
import MapKit
import RxSwift
import RealmSwift

class MinderMapTabViewModel : ViewModel{
    
    let userRepository = UserRepositoryImpl()
    let homeRepository = HomeRepositoryImpl()
    
    let viewMode = BehaviorRelay(value: MapViewMode.Map)
    let showSearchLocation = BehaviorRelay<Bool>(value: false)
    let locationSearchResult = BehaviorRelay<[Address]>(value: [])
    
    let mapListItems = BehaviorRelay<[MapListItem]>(value: [])
    let nearByUsers = BehaviorRelay<[UserAnnotation]>(value: [])
    let location = BehaviorRelay<LocationDetails?>(value: nil)
    let locationSelectionMode = BehaviorRelay<Bool>(value: false)
    let enableUpdateLocationFromDevice = BehaviorRelay<Bool>(value: true)
    let filterParams = BehaviorRelay<FilterParams?>(value: nil)
    let activeProfile = BehaviorRelay<ActiveProfile>(value: SessionManager.shared.userType ?? .FINDER)
    
    let realm = try! Realm()
    
    required init() {
        super.init()
    
        let locationResult = realm.objects(LocationDetails.self)
        
        Observable.arrayWithChangeset(from: locationResult).debounce(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
             .subscribe(onNext: { [unowned self] changeResult, changes in
                 let location = changeResult.first
            
                 if(self.location.value != nil && !self.enableUpdateLocationFromDevice.value){
                     return
                 }
                 if(location?.latitude == 0 || location?.longitude == 0){
                        LocationService.shared.getLocation()
                        return
                }
                 self.location.accept(location?.randomizeAccuracy())
                 if(mapListItems.value.isEmpty){
                     self.applyFilter(filterParams: FilterParams(findersPreference: nil, gender: nil, maxDistance: Config.MAP_LOCATION_FILTER_MAX_RADIUS))
                 }
                 
                 self.enableUpdateLocationFromDevice.accept(false)
             }).disposed(by: disposeBag)
        
        self.mapListItems.subscribe(onNext: {
            self.nearByUsers.accept($0.map{
                UserAnnotation(
                    id: $0.id,
                    coordinate: CLLocationCoordinate2DMake(
                        Double($0.address?.latitude ?? 0),
                        Double($0.address?.longitude ?? 0)
                    ),
                    name: $0.name,
                    distance: self.location.value?.getDistance(
                        latitude: $0.address?.latitude ?? nil,
                        longitude: $0.address?.longitude ?? nil
                    ).rangeText  ?? "N/A",
                    imageURL: $0.imageURL,
                    activeProfile: $0.activeProfile,
                    isProfileVerified: $0.activeProfile == .FINDER ? false : $0.isProfileVerified,
                    hasMinderProfile: $0.hasMinderProfile
                )
            })
        }).disposed(by: disposeBag)
        
    }
    
    func applyFilter(filterParams : FilterParams){
        self.filterParams.accept(filterParams)
        self.getNearByUsers(
            latitude:  location.value?.latitude ?? 0.0,
            longitude: location.value?.longitude ?? 0.0,
            maxDistance: Float(filterParams.maxDistance * 1000),
            gender : filterParams.gender,
            minderWithPet: filterParams.findersPreference?.rawValue
        )
    }
    
    func setActiveProfile(activeProfile : ActiveProfile){
        self.userRepository.updateUserDetails(
            activeProfile: activeProfile.rawValue,
            type: UserUpdateType.VIEW
        )
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            })
        .subscribe(onSuccess: {
            SessionManager.shared.user = $0
            SessionManager.shared.userType = $0.activeProfile
            
        },onFailure:self.error.accept).disposed(by: disposeBag)
    }
    
    
    private func getNearByUsers(
        latitude : Float ,
        longitude : Float,
        maxDistance: Float = 10000,
        gender: Gender? = nil,
        minderWithPet : String? = nil
    ){
        homeRepository.getNearbyUsers(latitude: latitude, longitude:longitude, maxDistance: maxDistance, minderWithPet: minderWithPet,gender:gender)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(
                onSuccess: { minderProfiles in
                    self.mapListItems.accept(minderProfiles.map{
                        
                        let randomizedAddress = $0.address?.randomizeAccuracy()
                        
                        return  MapListItem(
                            id:$0.id,
                            name: $0.fullName ?? "",
                            rating: ($0.minderProfile?.averageRating != nil) ? ( $0.minderProfile?.averageRating == 0 ? (String(format : "%.2f", $0.minderProfile!.averageRating!)) : "0") : "-",
                            experience: ($0.minderProfile?.yearsOfExperience != nil) ? String(describing: $0.minderProfile!.yearsOfExperience!) : "-",
                            availableDays: ["Sun","Mon","Tue"], //TODO:
                            perHourRate: ($0.minderProfile?.perHourRate != nil) ? String(describing: $0.minderProfile!.perHourRate!) : "-",
                            distance: self.location.value?.getDistance(
                                latitude: randomizedAddress?.latitude ?? nil,
                                longitude: randomizedAddress?.longitude ?? nil
                            )  ?? ("N/A",0.0),
                            imageURL: $0.image ?? "",
                            phone : $0.phoneNumber ?? "",
                            showMyNumber: !($0.hidePhoneNumber ?? false),
                            address: randomizedAddress,
                            activeProfile : $0.activeProfile,
                            isProfileVerified: $0.isProfileVerified(),
                            hasMinderProfile: $0.minderProfile != nil
                        )
                    })
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
                
    }
    
    func updateUsersLocation(locationDetails: LocationDetails){
        LocationService.shared.updateLocationForTravellingMinder(location: CLLocation(latitude: CLLocationDegrees(locationDetails.latitude), longitude: CLLocationDegrees(locationDetails.longitude)))
    }
    
}
