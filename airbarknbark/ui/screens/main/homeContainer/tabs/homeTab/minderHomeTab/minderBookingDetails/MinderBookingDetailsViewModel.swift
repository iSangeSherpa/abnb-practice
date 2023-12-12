//
//  MinderBookingDetailsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class MinderBookingDetailsViewModel : ViewModel{
    var requestId = ""
    let homeRepository = HomeRepositoryImpl()
    let userRepository = UserRepositoryImpl()
    
    let userId = BehaviorRelay<String>(value: "")
    let finderName = BehaviorRelay<String>(value: "")
    let userImage = BehaviorRelay<String>(value: "")
    let address = BehaviorRelay<String>(value: "")
    let phone = BehaviorRelay<String>(value: "")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    let bookedFor = BehaviorRelay<String>(value: "")
    let totalPay = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let totalPets = BehaviorRelay<String>(value: "")
    let status = BehaviorRelay<RequestStatus?>(value: nil)
    let extraNotes = BehaviorRelay<String>(value: "")
    let isProfileVerified = BehaviorRelay<Bool>(value: false)
    
    let selectedPetItems =  BehaviorRelay<[PetDetails]>(value: [])
    
    let onClockInSuccess = PublishRelay<Void>()
    let onBlockUserSuccess = PublishRelay<Void>()

    func getReceivedMindingRequestDetails(){
        homeRepository.getReceivedMindingRequestDetails(requestId: requestId)
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
                    
                    self.userId.accept(details.finderUserId)
                    self.finderName.accept(details.finder?.fullName ?? "N/A")
                    self.userImage.accept(details.finder?.image ?? "N/A")
                    self.address.accept(details.finder?.address?.name ?? "N/A")
                    self.phone.accept(details.finder?.phoneNumber ?? "N/A")
                    self.showMyNumber.accept(!(details.finder?.hidePhoneNumber ?? false))
                    self.bookedFor.accept(details.from.asDateTime().asPreetyDateString())
                    self.time.accept(
                        "\(details.from.asDateTime().asTimeString()) - \(details.to.asDateTime().asTimeString())"
                    )
                    self.totalPay.accept("\(details.currency.symbol) \(String(format:"%.2f", totalPay))")
                    self.extraNotes.accept(details.message)
                    self.totalPets.accept("\(details.pets.count)")
                    self.status.accept(details.status)
                    self.isProfileVerified.accept(details.finder?.isProfileVerified() ?? false)
                    
                    self.selectedPetItems.accept(
                        details.pets
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
    
    func startClockIn(){
        homeRepository.clockIn(requestId: requestId)
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
                    self.onClockInSuccess.accept(Void())
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)

    }
    
    func cancelRequest(){
        homeRepository.cancelMindingRequest(requestId: requestId)
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
                    self.onClockInSuccess.accept(Void())
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)

    }

}
