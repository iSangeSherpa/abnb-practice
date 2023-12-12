//
//  MinderRequestDetailsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class MinderRequestDetailsViewModel : ViewModel{
    var requestId = ""
    let homeRepository = HomeRepositoryImpl()
    let userRepository = UserRepositoryImpl()
    let conversationRepository = ConversationRepositoryImp()
    
    let userId = BehaviorRelay<String>(value: "")
    let finderName = BehaviorRelay<String>(value: "")
    let userImage = BehaviorRelay<String>(value: "")
    let address = BehaviorRelay<String>(value: "California, US")
    let phone = BehaviorRelay<String>(value: "+1 242393434")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    let isProfileVerified = BehaviorRelay<Bool>(value: false)
    
    let bookedFor = BehaviorRelay<String>(value: "")
    let totalPay = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let totalPets = BehaviorRelay<String>(value: "")
    let status = BehaviorRelay<RequestStatus?>(value: nil)
    let extraNotes = BehaviorRelay<String>(value: "")
    
    let selectedPetItems =  BehaviorRelay<[PetDetails]>(value: [])
 
    let onUpdateSuccess = PublishRelay<Void>()
    let onBlockUserSuccess = PublishRelay<Void>()
    
    required init() {
        super.init()
    }
    
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
                    self.isProfileVerified.accept(details.finder?.isProfileVerified() ?? false)
                    
                    self.bookedFor.accept(details.from.asDateTime().asPreetyDateString())
                    self.time.accept(
                        "\(details.from.asDateTime().asTimeString()) - \(details.to.asDateTime().asTimeString())"
                    )
                    self.totalPay.accept("\(details.currency.symbol) \(String(format:"%.2f", totalPay))")
                    self.extraNotes.accept(details.message)
                    self.totalPets.accept("\(details.pets.count)")
                    self.status.accept(details.status)
                    
                    self.selectedPetItems.accept(details.pets)
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

    
    func acceptRequest(){
        homeRepository.acceptMindingRequest(requestId: requestId)
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
                    self.onUpdateSuccess.accept(Void())
                },
                onFailure: error.accept
            ).disposed(by: disposeBag)
    }
    
    func declineAndSendMessage(message:String){
        let declineRequestObservable = homeRepository.declineMindingRequest(requestId: requestId)
        
        let getConversationDetailObservable =  conversationRepository.startConversation(receiverId: userId.value)
        
        Single.zip(declineRequestObservable,getConversationDetailObservable)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                })
                .flatMapCompletable{ (_,conversationId) in
                    self.conversationRepository.sendNewMessage(conversationId: conversationId,text: message)
                }
                .subscribe(
                    onCompleted:{self.onUpdateSuccess.accept(Void())},
                    onError: error.accept
                )
                .disposed(by: disposeBag)
           
    }
}
