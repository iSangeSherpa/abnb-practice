//
//  HomeTabViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxSwift
import RxRelay
import MapKit
import RealmSwift

enum MapViewMode{
    case Map
    case List
}

class FinderMapTabViewModel : ViewModel{
    
    let userRepository = UserRepositoryImpl()
    let homeRepository = HomeRepositoryImpl()
    let conversationRepository = ConversationRepositoryImp()
    
    let viewMode = BehaviorRelay(value: MapViewMode.Map)
    let showSearchLocation = BehaviorRelay<Bool>(value: false)
    let locationSearchResult = BehaviorRelay<[Address]>(value: [])
    
    let mapListItems = BehaviorRelay<[MapListItem]>(value: [])
    let nearByUsers = BehaviorRelay<[UserAnnotation]>(value: [])
    let onFilterClicked = PublishRelay<FilterParams>()
    let filterParams = BehaviorRelay<FilterParams?>(value: nil)
    let location = BehaviorRelay<LocationDetails?>(value: nil)
    let enableUpdateLocationFromDevice = BehaviorRelay<Bool>(value: true)
    let onConversationStart = PublishRelay<String>()
    
    let locationSelectionMode = BehaviorRelay<Bool>(value: false)
    let activeProfile = BehaviorRelay<ActiveProfile>(value: SessionManager.shared.userType ?? .FINDER)
    
    let realm = try! Realm()
    
    
    required init() {
        super.init()
        
        let locationResult = realm.objects(LocationDetails.self)
        
        Observable.arrayWithChangeset(from: locationResult).debounce(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] changeResult, changes in
                if(self.location.value != nil && !self.enableUpdateLocationFromDevice.value){
                    return
                }
                self.location.accept(changeResult.first?.randomizeAccuracy())
                if(mapListItems.value.isEmpty){
                    self.searchMinders(filterParams: FilterParams(findersPreference: nil, gender: nil, maxDistance: Config.MAP_LOCATION_FILTER_MAX_RADIUS))
                }
                
                self.enableUpdateLocationFromDevice.accept(false)
            }).disposed(by: disposeBag)
        
        self.mapListItems.subscribe(onNext: {
            self.nearByUsers.accept($0.map{
                UserAnnotation(
                    id: $0.address?.userId ?? "",
                    coordinate: CLLocationCoordinate2DMake(
                        Double($0.address?.latitude ?? 0),
                        Double($0.address?.longitude ?? 0)
                    ),
                    name: $0.name,
                    distance: self.location.value?.getDistance(
                        latitude: $0.address?.latitude ?? nil,
                        longitude: $0.address?.longitude ?? nil,
                        appendingText: "away"
                    ).rangeText  ?? "N/A",
                    imageURL: $0.imageURL,
                    activeProfile: $0.activeProfile,
                    isProfileVerified:  $0.isProfileVerified,
                    hasMinderProfile : $0.hasMinderProfile
                )
            })
        }).disposed(by: disposeBag)
        
        if(location.value == nil){
            LocationService.shared.getLocation()
        }
        
    }
    
    
    private func getNearbyUsers(
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
                        
                        let randomizeAddress = $0.address?.randomizeAccuracy()
                        
                        return  MapListItem(
                            id:$0.id,
                            name: $0.fullName ?? "",
                            rating:  ($0.getAverageRating() == 0) ? "N/A" : "\(String(format: "%.1f",$0.getAverageRating())) stars",
                            experience: ($0.minderProfile?.yearsOfExperience != nil) ? String(describing: "\($0.minderProfile!.yearsOfExperience!) Year Exp") : "-",
                            availableDays: ["Sun","Mon","Tue"], //TODO:
                            perHourRate: ($0.minderProfile?.perHourRate != nil) ? String(describing: $0.minderProfile!.perHourRate!) : "-",
                            distance: self.location.value?.getDistance(
                                latitude: randomizeAddress?.latitude ?? nil,
                                longitude: randomizeAddress?.longitude ?? nil
                            )  ?? ("N/A",0.0),
                            imageURL: $0.image ?? "",
                            phone : $0.phoneNumber ?? "",
                            showMyNumber: !($0.hidePhoneNumber ?? false),
                            address: randomizeAddress,
                            activeProfile : $0.activeProfile,
                            isProfileVerified: $0.isProfileVerified(),
                            hasMinderProfile: $0.minderProfile != nil
                        )
                    }.sorted(by:{ $0.distance.1 < $1.distance.1 }))
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
                
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
        .subscribe(onSuccess: { userDetails in
                SessionManager.shared.user = userDetails
                SessionManager.shared.userType = userDetails.activeProfile
        },onFailure:self.error.accept).disposed(by: disposeBag)
    }
    
    func searchMinders(filterParams : FilterParams){
        self.filterParams.accept(filterParams)
        self.getNearbyUsers(
            latitude:  location.value?.latitude ?? 0,
            longitude: location.value?.longitude ?? 0,
            maxDistance: Float(filterParams.maxDistance * 1000),
            gender : filterParams.gender,
            minderWithPet: filterParams.findersPreference?.rawValue
        )
    }
    
    func startConversation(receiverUserId : String){
        conversationRepository.startConversation(receiverId: receiverUserId )
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { conversationId in
                    self.onConversationStart.accept(conversationId)
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
    
    func updateUsersLocation(locationDetails: LocationDetails){
        LocationService.shared.updateLocationForTravellingMinder(location: CLLocation(latitude: CLLocationDegrees(locationDetails.latitude), longitude: CLLocationDegrees(locationDetails.longitude)))
    }
}
