//
//  RequestDetails.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 04/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class FinderRequestDetailsViewModel:ViewModel{
    var requestId = ""
    let userRepository = UserRepositoryImpl()
    let homeRepository = HomeRepositoryImpl()
    
    let userId = BehaviorRelay<String>(value: "")
    let minderName = BehaviorRelay<String>(value: "")
    let userImage = BehaviorRelay<String>(value: "")
    let rating = BehaviorRelay<String>(value: "")
    let experience = BehaviorRelay<String>(value: "")
    let address = BehaviorRelay<String>(value: "California, US")
    let phone = BehaviorRelay<String>(value: "+1 242393434")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    let bookedFor = BehaviorRelay<String>(value: "")
    let totalPay = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let totalPets = BehaviorRelay<String>(value: "")
    let status = BehaviorRelay<RequestStatus?>(value: nil)
    let extraNotes = BehaviorRelay<String>(value: "")
    let isProfileVerified = BehaviorRelay<Bool>(value: false)
    
    let selectedPetItems =  BehaviorRelay<[PetDetails]>(value: [])
    
    let reviewsItems =  BehaviorRelay<[ReviewsItem]>(value: [])
    
    let onBookingCancelled = PublishRelay<Void>()
    
    let onBlockUserSuccess = PublishRelay<Void>()
    
    required init() {
        super.init()
    }
    
    func getSentMindingRequestDetails(){
        homeRepository.getSentMindingRequestDetails(requestId: requestId)
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
                    let totalTime = DateUtils.getElapsedTime(from: details.from.asDateTime(),
                                                             to: details.to.asDateTime())
                    let totalPay = (abs(Float(totalTime!.hr)) * details.perHourRate) + (abs(Float(totalTime!.min)) * details.perHourRate / 60)
                    self.userId.accept(details.minderUserId)
                    self.minderName.accept(details.minder?.fullName ?? "N/A")
                    self.userImage.accept(details.minder?.image ?? "")
                    self.rating.accept(
                        (details.minder?.minderProfile?.averageRating != nil) ?
                        String(format : "%.0f", (details.minder?.minderProfile?.averageRating)!) : "-" )
                    
                    self.experience.accept(
                        (details.minder?.minderProfile?.yearsOfExperience != nil) ?
                        String(format : "%.1f Year Exp", (details.minder?.minderProfile?.yearsOfExperience)!) : "-" )
                    
                    self.address.accept(details.minder?.address?.name ?? "N/A")
                    self.phone.accept(details.minder?.phoneNumber ?? "N/A")
                    self.showMyNumber.accept(!(details.minder?.hidePhoneNumber ?? false))
                    self.isProfileVerified.accept(details.minder?.isProfileVerified() ?? false)
                    
                    self.bookedFor.accept(details.from.asDateTime().asPreetyDateString())
                    self.time.accept(
                        "\(details.from.asDateTime().asTimeString()) - \(details.to.asDateTime().asTimeString())"
                    )
                    self.totalPay.accept("\(details.currency.symbol) \(String(format:"%.2f", totalPay))")
                    self.extraNotes.accept(details.message)
                    self.totalPets.accept("\(details.pets.count)")
                    self.status.accept(details.status)
                    
                    self.selectedPetItems.accept(details.pets)
                    
                    self.reviewsItems.accept(
                        details.reviews.map {
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).map{
                                ReviewsItem(name: $0.fromUser?.fullName ?? "", avatarImage: $0.fromUser?.image ?? "", review: $0.message, rating: "\($0.rating)",images: $0.images,to: (($0.toUser != nil) ? $0.toUser?.fullName : $0.toPet?.name) ?? "")
                            }
                        } ?? []
                    )
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }

    func reportAccount(message : String){
        userRepository.reportUser(message:message, toUserId: self.userId.value)
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
        userRepository.blockUser(toUserId: self.userId.value)
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
    
    func cancelBooking(){
        homeRepository.cancelBooking(requestId: requestId)
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
                    self.onBookingCancelled.accept(Void())
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
}
