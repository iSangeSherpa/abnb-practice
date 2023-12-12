//
//  BothHomeTabViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/01/2023.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

class BothHomeTabViewModel : ViewModel{
    let homeRepository = HomeRepositoryImpl()
    let userRepository = UserRepositoryImpl()
    let notificationsRepository = NotificationsRepositoryImpl()
    
    let minderAvailableStatus: Observable<MinderAvailableStatus?> = SessionManager.shared.availableStatusFlow
    
    let onActiveMindingsForItemClicked = PublishRelay<String>()
    let onRequestsForItemClicked = PublishRelay<String>()
    let onBookingsForItemClicked = PublishRelay<String>()
    
    let onActiveMindingsByItemClicked = PublishRelay<String>()
    let onRequestsByItemClicked = PublishRelay<String>()
    let onBookingsByItemClicked = PublishRelay<String>()
    
    let onSeeAllForBookingsClicked = PublishRelay<Void>()
    let onSeeAllForRequestsClicked = PublishRelay<Void>()
    
    let onSeeAllByBookingsClicked = PublishRelay<Void>()
    let onSeeAllByRequestsClicked = PublishRelay<Void>()
    
    let availabilitySwitchChanged = PublishRelay<Bool>()
    
    let activeMindingForItems =  BehaviorRelay<[MindingItem]>(value: [])
    let requestForItems = BehaviorRelay<[MindingRequestItem]>(value: [])
    let bookingForItems = BehaviorRelay<[BookingItem]>(value: [])
   
    let activeMindingByItems =  BehaviorRelay<[MindingItem]>(value: [])
    let requestByItems = BehaviorRelay<[MindingRequestItem]>(value: [])
    let bookingByItems = BehaviorRelay<[BookingItem]>(value: [])
    let recentSessionItems = BehaviorRelay<[PastWorksItem]>(value: [])
    
    let hasUnreadNotification = BehaviorRelay<Bool>(value: false)
    
    let name = BehaviorRelay<String>(value: "")
    
    let greeting = BehaviorRelay<String>(value: "")
    
    let activeMindingsActiveTab = BehaviorRelay<ForByToggleView.ForBy>(value: .FOR)
    let requestsActiveTab = BehaviorRelay<ForByToggleView.ForBy>(value: .FOR)
    let bookingsActiveTab = BehaviorRelay<ForByToggleView.ForBy>(value: .FOR)
    
    required init() {
        super.init()
        
        notificationsRepository.getAllNotificationsFlow()
            .bind(onNext: { notificationList in
                self.hasUnreadNotification.accept(!(notificationList.filter{!($0.isSeen)}.isEmpty))
            }).disposed(by: disposeBag)
        
        self.refreshNotifications()
        
        self.getBothRequests()
    }
    func refreshNotifications(){
        notificationsRepository.refreshNotifications()
            .subscribe(onError: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func getBothRequests(){
        
        let firstName = SessionManager.shared.user?.fullName?.split(separator: " ").first ?? ""
        name.accept("Hello \(String(firstName))")
        greeting.accept(Utils.getGreetingsText())
        
        
        let receivedMindingRequests =  self.homeRepository.getReceivedMindingRequests()
        let sentMindingRequests =  self.homeRepository.getSentMindingRequests()
       
        Single.zip(receivedMindingRequests,sentMindingRequests).observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                    
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                    onSuccess: { receivedRequests,sentRequests in
                        //Minding for || Ongoing Session
                        self.activeMindingForItems.accept(
                            receivedRequests.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{
                                mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry = mindingRequest.entry  else {return false}
                                return (entry.clockIn != nil) && (entry.clockOut == nil)
                            }.map{
                                let timeLeft = DateUtils.getElapsedTime(from: $0.to.asDateTime())
                                let isOvertime = timeLeft!.hr < 0 || timeLeft!.min < 0
                                let timeLeftValue = (timeLeft == nil) ? ("N/A") :
                                "\(isOvertime ? "+" : "")\(timeLeft!.hr != 0 ? "\(abs(timeLeft!.hr))hr " : "")\(abs(timeLeft!.min))min \(isOvertime ? "" : "left")"
                                return MindingItem(
                                    id: $0.id,
                                    name: $0.finder?.fullName ?? "",
                                    imageURL: $0.finder?.image ?? "",
                                    leftTime: timeLeftValue,
                                    location: $0.finder?.address?.name ?? "-",
                                    startedTime:  "Started from: \($0.entry?.clockIn?.asDateTime().asTimeString() ?? "")",
                                    isProfileVerified: $0.finder?.isProfileVerified() ?? false
                                )
                            }
                        )
                               
                        
                        //Minding Requests
                        let receivedRequestsTemp = receivedRequests.filter{ mindingRequest in
                            return mindingRequest.status == .PENDING
                        }.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() })
                        
                        self.requestByItems.accept(
//                            (receivedRequestsTemp.filter{$0.status == .PENDING} + receivedRequestsTemp.filter{$0.status != .PENDING})
                                receivedRequestsTemp.map{
                                MindingRequestItem(
                                    id: $0.id,
                                    name: $0.finder?.fullName ?? "",
                                    imageURL: $0.finder?.image ?? "",
                                    date: $0.createdAt.asDateTime().asPreetyDateString(),
                                    requestStatus: $0.status,
                                    isProfileVerified: $0.finder?.isProfileVerified() ?? false
                                )
                            }
                        )
                        
                        
                        //Bookings
                        self.bookingByItems.accept(
                            receivedRequests.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry =  mindingRequest.entry else {return false}
                                return (entry.clockIn == nil) && (entry.clockOut == nil)
                            }.map{
                                BookingItem(id: $0.id,
                                            name: $0.finder?.fullName ?? "...",
                                            imageURL: $0.finder?.image ?? "",
                                            date: $0.from.asDateTime().asPreetyDateString(),
                                            timeDuration: "\($0.from.asDateTime().asTimeString()) - \($0.to.asDateTime().asTimeString())" ,
                                            rate: String(describing:$0.perHourRate), perTime: "per hour",
                                            isProfileVerified: $0.finder?.isProfileVerified() ?? false
                                )
                            }
                        )
                        
                        
                        //Minding By || Ongoing Session
                        self.activeMindingByItems.accept(
                            sentRequests.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{
                                mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry = mindingRequest.entry  else {return false}
                                return (entry.clockIn != nil) && (entry.clockOut == nil)
                            }.map{
                                let timeLeft = DateUtils.getElapsedTime(from: $0.to.asDateTime())
                                let isOvertime = timeLeft!.hr < 0 || timeLeft!.min < 0
                                let timeLeftValue = (timeLeft == nil) ? ("N/A") :
                                "\(isOvertime ? "+" : "")\(timeLeft!.hr != 0 ? "\(abs(timeLeft!.hr))hr " : "")\(abs(timeLeft!.min))min \(isOvertime ? "" : "left")"
                                return MindingItem(
                                    id: $0.id,
                                    name: $0.minder?.fullName ?? "",
                                    imageURL: $0.minder?.image ?? "",
                                    leftTime: timeLeftValue,
                                    location: $0.minder?.address?.name ?? "",
                                    startedTime:  "Started from: \( $0.entry?.clockIn?.asDateTime().asTimeString() ?? "")",
                                    isProfileVerified: $0.minder?.isProfileVerified() ?? false
                                )
                            }
                        )
                        
                        
                        //Minding Requests
                        
                        let requestForItemsTemp = sentRequests.filter{ mindingRequest in
                            return mindingRequest.status == .PENDING
                        }.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() })
                        
                        self.requestForItems.accept(
//                            (requestForItemsTemp.filter{$0.status == .PENDING} + requestForItemsTemp.filter{$0.status != .PENDING})
                                requestForItemsTemp.map{
                                    MindingRequestItem(
                                        id: $0.id,
                                        name: $0.minder?.fullName ?? "",
                                        imageURL: $0.minder?.image ?? "",
                                        date: $0.createdAt.asDateTime().asPreetyDateString(),
                                        requestStatus: $0.status,
                                        isProfileVerified: $0.minder?.isProfileVerified() ?? false
                                    )
                                }
                        )
                        
                        
                        //Bookings
                        self.bookingForItems.accept(
                            sentRequests.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry =  mindingRequest.entry else {return false}
                                return (entry.clockIn == nil) && (entry.clockOut == nil)
                            }.map{
                                BookingItem(id: $0.id,
                                            name: $0.minder?.fullName ?? "...",
                                            imageURL: $0.minder?.image ?? "",
                                            date: $0.from.asDateTime().asPreetyDateString(),
                                            timeDuration: "\($0.from.asDateTime().asTimeString()) - \($0.to.asDateTime().asTimeString())",
                                            rate: String(describing:$0.perHourRate), perTime: "per hour",
                                            isProfileVerified: $0.minder?.isProfileVerified() ?? false
                                )
                            }
                        )
                        
                        //RecentSession
                        self.recentSessionItems.accept(
                            sentRequests.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry =  mindingRequest.entry else {return false}
                                return (entry.clockIn != nil) && (entry.clockOut != nil)
                            }.map{
                                let totalTime = DateUtils.getElapsedTime(from: $0.entry?.clockIn!.asDateTime(),
                                                                         to: $0.entry?.clockOut!.asDateTime())
                                let totalPay = (abs(Float(totalTime!.hr)) * $0.perHourRate) + (abs(Float(totalTime!.min)) * $0.perHourRate / 60)

                                let date = $0.from.asDateTime().asPreetyDateString()

                                let time = "\($0.from.asDateTime().asTimeString()) - \($0.to.asDateTime().asTimeString())"

                                return PastWorksItem(
                                    id: $0.id,
                                    name: $0.minder?.fullName ?? "",
                                    imageURL: $0.minder?.image ?? "",
                                    date: date,
                                    time: time,
                                    totalReceived: "\($0.currency.symbol) \(String(format:"%.2f",totalPay))",
                                    isProfileVerified: $0.minder?.isProfileVerified() ?? false
                                )
                            }
                        )
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
                }
    
    
    func updateAvailabilityStatus(availableStatus : Bool){
        let param : Parameters = [ "availableStatus" : (availableStatus ? MinderAvailableStatus.AVAILABLE.rawValue : MinderAvailableStatus.NOT_AVAILABLE.rawValue) ]
        self.userRepository.updateMinderProfile(
            minderProfileRequestParams: param)
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
                    self?.setAvailableStatus(availableStatus: (it.availableStatus))
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
            
    func setAvailableStatus(availableStatus : MinderAvailableStatus){
        SessionManager.shared.availableStatus = availableStatus
    }
    
}
