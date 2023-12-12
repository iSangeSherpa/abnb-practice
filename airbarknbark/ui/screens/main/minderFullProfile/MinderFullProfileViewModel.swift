//
//  MinderFullProfileViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 11/11/2022.
//

import Foundation
import RxRelay
import RxSwift
import RealmSwift

struct AvailabilityDays{
    let day: String
    let isAvailable: Bool
    let from : String
    let to : String
}

class MinderFullProfileViewModel : ViewModel{
    var minderUserId = ""
    let userRepository = UserRepositoryImpl()
    let conversationRepository = ConversationRepositoryImp()
    
    let availabilityDaysItems = BehaviorRelay<[Selectable<AvailabilityDays>]>(value: [])
    let availabilityTime = BehaviorRelay<AvailabilityDays?>(value: nil)
    
    let dayClicked =  PublishRelay<Selectable<AvailabilityDays>>()
    
    let breedItems = BehaviorRelay<[String]>(value: [])
    let petBehaviourItems = BehaviorRelay<[String]>(value: [])
    let onCreateRequestClicked = PublishRelay<Void>()
    let onConversationStart = PublishRelay<String>()
    let onBlockUserSuccess = PublishRelay<Void>()
    
    let reviewsItems =  BehaviorRelay<[ReviewsItem]>(value: [])
    
    let name = BehaviorRelay<String>(value: "")
    let userImage = BehaviorRelay<String>(value: "")
    let addressName = BehaviorRelay<String>(value: "")
    let phone = BehaviorRelay<String>(value: "")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    
    let shortBio = BehaviorRelay<String>(value: "")
    let rate = BehaviorRelay<String>(value: "")
    let yearsOfExpereince = BehaviorRelay<String>(value: "")
    let rating = BehaviorRelay<String>(value: "")
    let locationDistance = BehaviorRelay<String>(value: "")
    let dogSize = BehaviorRelay<[PetSizePreferences]>(value: [])
    let userDetails = BehaviorRelay<UserDetails?>(value:nil)
    
    let petsDetails = BehaviorRelay<[PetDetails]>(value: [])
    
    let realm = try! Realm()
    
    let location = BehaviorRelay<LocationDetails?>(value: nil)
    
    required init() {
        super.init()
        let locationResult = realm.objects(LocationDetails.self)
        
        Observable.arrayWithChangeset(from: locationResult)
             .subscribe(onNext: { [unowned self] changeResult, changes in
                 self.location.accept(changeResult.first)
             }).disposed(by: disposeBag)
        
        
        dayClicked.withLatestFrom(availabilityDaysItems) { item, items in
            items.map { it in
                it.item.day == item.item.day ? it.copy(isSelected: !it.isSelected) : it
            }
        }.bind(to: availabilityDaysItems)
            .disposed(by: disposeBag)
    }
    
    
    func getMinderProfile(){
        userRepository.getUserDetails(userId: self.minderUserId)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { [weak self] it in
                    self?.userDetails.accept(it)
                    self?.name.accept(it.fullName ?? "")
                    self?.userImage.accept(it.image ?? "")
                    self?.addressName.accept(it.address?.name ?? "N/A")
                    self?.phone.accept(it.phoneNumber ?? "N/A")
                    self?.showMyNumber.accept(!(it.hidePhoneNumber ?? false))
                    
                    self?.rate.accept((it.minderProfile?.perHourRate == nil) ? "N/A" : String(describing: (it.minderProfile?.perHourRate)!))
                    self?.yearsOfExpereince.accept((it.minderProfile?.yearsOfExperience == nil) ? "N/A" : (String(describing: (it.minderProfile?.yearsOfExperience)!)) + " years")
                    
                    self?.rating.accept( (it.getAverageRating() == 0) ? "N/A" : "\(String(format: "%.1f",it.getAverageRating())) stars")
                    
                    self?.locationDistance.accept(
                        self?.location.value?.getDistance(
                            latitude: it.address?.latitude ?? nil,
                            longitude: it.address?.longitude ?? nil,
                            appendingText: "away from you"
                        ).rangeText  ?? "N/A"
                    )
                    self?.shortBio.accept(it.bio ?? "")
                    self?.availabilityDaysItems.accept(
                        
                        it.minderProfile?.minderAvailability.map{ availableDays in
                            availableDays.map{
                                Selectable(
                                    item: AvailabilityDays(
                                        day: $0.dayOfWeek,
                                        isAvailable: ($0.from != "00:00" && $0.to != "00:00"),
                                        from: $0.from ,
                                        to : $0.to
                                    ) ,
                                    isSelected: false)
                            }
                            
                        } ?? []
                        
                        
                    )
                    self?.dogSize.accept(it.minderProfile?.petSizePreferences ?? [])
                    self?.breedItems.accept(it.minderProfile?.breedPreferences.map{$0.map{$0.name}} ?? [])
                    self?.petBehaviourItems.accept(it.minderProfile?.petBehaviorPreferences ?? [])
                  
                    self?.reviewsItems.accept(
                        it.receivedReviews.map {
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).map{
                                ReviewsItem(name: $0.fromUser?.fullName ?? "", avatarImage: $0.fromUser?.image ?? "", review: $0.message, rating: "\($0.rating)",images: $0.images,to: (($0.toUser != nil) ? $0.toUser?.fullName : $0.toPet?.name) ?? "")
                            }
                        } ?? []
                    )
        
                    if let petsArray = it.pets {
                        self?.petsDetails.accept(petsArray)
                    }
                
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
                }
    
    
    func reportAccount(message : String){
        userRepository.reportUser(message:message, toUserId: self.minderUserId)
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
                onSuccess: { details in
                    self.alerts.accept(.success(.Dialog.reportAccountSuccess))
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
    
    func blockAccount(){
        userRepository.blockUser(toUserId: self.minderUserId)
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
                onSuccess: { details in
                    self.onBlockUserSuccess.accept(Void())
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
    
    func startConversation(){
        conversationRepository.startConversation(receiverId: minderUserId )
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
                onSuccess: { conversationId in
                    self.onConversationStart.accept(conversationId)
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
}
