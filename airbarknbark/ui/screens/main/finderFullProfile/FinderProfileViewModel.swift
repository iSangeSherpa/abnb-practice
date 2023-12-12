//
//  FinderProfileViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/12/2022.
//

import Foundation
import RxRelay
import RealmSwift
import RxSwift

class FinderProfileViewModel : ViewModel{
    var finderUserId = ""
    
    let userRepository = UserRepositoryImpl()
    let conversationRepository = ConversationRepositoryImp()

    let reviews =  BehaviorRelay<[ReviewsItem]>(value: [])
    
    let name = BehaviorRelay<String>(value: "")
    let userImage = BehaviorRelay<String>(value: "")
    let addressName = BehaviorRelay<String>(value: "")
    let phone = BehaviorRelay<String>(value: "")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    
    let shortBio = BehaviorRelay<String>(value: "")
    let rating = BehaviorRelay<String>(value: "4.3")
    let locationDistance = BehaviorRelay<String>(value: "2.4 km away from you")
    let petsDetails = BehaviorRelay<[PetDetails]>(value: [])
    
    let realm = try! Realm()
    
    let location = BehaviorRelay<LocationDetails?>(value: nil)
    let user = BehaviorRelay<UserDetails?>(value: nil)
    
    let onBlockUserSuccess = PublishRelay<Void>()
    
    required init() {
        super.init()
        let locationResult = realm.objects(LocationDetails.self)
        
        Observable.arrayWithChangeset(from: locationResult)
             .subscribe(onNext: { [unowned self] changeResult, changes in
                 self.location.accept(changeResult.first)
             }).disposed(by: disposeBag)
    }
    
    
    func getFinderProfile(){
        userRepository.getUserDetails(userId: self.finderUserId)
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
                    self?.user.accept(it)
                    self?.name.accept(it.fullName ?? "")
                    self?.userImage.accept(it.image ?? "")
                    self?.addressName.accept(it.address?.name ?? "N/A")
                    self?.phone.accept(it.phoneNumber ?? "N/A")
                    self?.showMyNumber.accept(!(it.hidePhoneNumber ?? false))
                    
                    self?.rating.accept((it.getAverageRating() == 0) ? "N/A" : "\(String(format: "%.1f",it.getAverageRating())) stars")
                    self?.locationDistance.accept(
                        self?.location.value?.getDistance(
                            latitude: it.address?.latitude ?? nil,
                            longitude: it.address?.longitude ?? nil,
                            appendingText: "away from you"
                        ).rangeText  ?? "N/A"
                    )
                    self?.shortBio.accept(it.bio ?? "")
                   
                    self?.reviews.accept(
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
        userRepository.reportUser(message:message, toUserId: self.finderUserId)
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
        userRepository.blockUser(toUserId: self.finderUserId)
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
}
