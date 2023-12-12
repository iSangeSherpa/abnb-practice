//
//  FinderDetailsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class MindingForDetailsViewModel: ViewModel{
    var requestId = ""
    let userRepository = UserRepositoryImpl()
    let homeRepository = HomeRepositoryImpl()
    let conversationRepository = ConversationRepositoryImp()
    
    let triggerHomeRefresh = PublishRelay<Void>()
    let name = BehaviorRelay<String>(value: "")
    let userImage = BehaviorRelay<String>(value: "")
    let address = BehaviorRelay<String>(value: "")
    let phone = BehaviorRelay<String>(value: "")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    
    let bookedFor = BehaviorRelay<String>(value: "")
    let bookedAddress = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let totalPets = BehaviorRelay<String>(value: "")
    
    let startTime = BehaviorRelay<String>(value:"")
    let endTime = BehaviorRelay<String>(value: "")
    let remainingTime = BehaviorRelay<String>(value: "")
    let totalPay = BehaviorRelay<String>(value: "")
    
    let timeCompleted = BehaviorRelay<String?>(value: nil)
    let isOvertime = BehaviorRelay<Bool>(value: false)
    
    let reviews =  BehaviorRelay<[ReviewsItem]>(value: [])
    
    let onClockOut = PublishRelay<Void>()
    let onConversationStart = PublishRelay<String>()
    var finderUserId : String? = nil
    var pets : [PetDetails] = []
    
    let sessionCompleted = BehaviorRelay<Bool>(value: false)
    let onBlockUserSuccess = PublishRelay<Void>()
    let isProfileVerified = BehaviorRelay<Bool>(value: false)
    
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
                    self.updateDetails(details: details)
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
    
    func clockOut(){
        homeRepository.clockOut(requestId: requestId)
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
                    self.onClockOut.accept(Void())
                    self.updateDetails(details: details)
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)

    }
    
    func reportAccount(message : String){
        guard let toUserId = self.finderUserId else {return}
        userRepository.reportUser(message:message, toUserId: toUserId)
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
        guard let toUserId = self.finderUserId else {return}
        userRepository.blockUser(toUserId: toUserId)
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
        guard let receiverUserId = finderUserId else {return}
        conversationRepository.startConversation(receiverId: receiverUserId )
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
    
    func updateDetails(details: MindingRequestDetails ){
        self.sessionCompleted.accept(details.getMindingRequestType() == .COMPLETED)
        
        let timeLeft = DateUtils.getElapsedTime(from:  details.to.asDateTime())
        self.isOvertime.accept(timeLeft!.hr < 0 || timeLeft!.min < 0)
        
        let timeCompleted = (details.getMindingRequestType() == .COMPLETED) ? DateUtils.getElapsedTime(from:details.entry!.clockOut!.asDateTime(), to: details.entry!.clockIn!.asDateTime()) : DateUtils.getElapsedTime(from:details.entry!.clockIn!.asDateTime())
        let totalPay = (abs(Float(timeCompleted!.hr)) * details.perHourRate) + (abs(Float(timeCompleted!.min)) * details.perHourRate / 60)
    
        if(details.getMindingRequestType() == .COMPLETED){
            self.remainingTime.accept((timeCompleted == nil) ? ("N/A") : (timeCompleted!.hr == 0) ? "\(timeCompleted!.min) minutes" : "\(timeCompleted!.hr) hr \(timeCompleted!.min) min")
        }else{
            let timeLeftValue = (timeLeft == nil) ? ("N/A") :
            "\(self.isOvertime.value ? "+ " : "")\(timeLeft!.hr != 0 ? "\(abs(timeLeft!.hr)) hr " : "")\(abs(timeLeft!.min)) min"
            self.remainingTime.accept(timeLeftValue)
        }
        
        self.name.accept(details.finder?.fullName ?? "N/A")
        self.userImage.accept(details.finder?.image ?? "")
        self.address.accept(details.finder?.address?.name ?? "N/A")
        self.phone.accept(details.finder?.phoneNumber ?? "N/A")
        self.showMyNumber.accept(!(details.finder?.hidePhoneNumber ?? false))
        self.isProfileVerified.accept(details.finder?.isProfileVerified() ?? false)
        
        self.bookedFor.accept( details.from.asDateTime().asPreetyDateString())
        self.time.accept(
            "\(details.from.asDateTime().asTimeString()) - \(details.to.asDateTime().asTimeString())"
        )
        self.bookedAddress.accept(details.addressName ?? "N/A")
        self.totalPets.accept("\(details.pets.count)")
        
        
        self.startTime.accept(details.entry?.clockIn?.asDateTime().asTimeString() ?? "N/A")
        self.endTime.accept(details.entry?.clockOut?.asDateTime().asTimeString() ?? "N/A")
        
        self.totalPay.accept("\(details.currency.symbol) \(String(format:"%.2f",totalPay))")
        
        
        self.reviews.accept(
            details.reviews.map {
                $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).map{
                    ReviewsItem(name: $0.fromUser?.fullName ?? "", avatarImage: $0.fromUser?.image ?? "", review: $0.message, rating: "\($0.rating)",images: $0.images,to: (($0.toUser != nil) ? $0.toUser?.fullName : $0.toPet?.name) ?? "")
                }
            } ?? []
        )
        self.finderUserId = details.finderUserId
        self.pets = details.pets
    }
}
