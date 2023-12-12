//
//  HomeTabViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxRelay
import RxSwift

class FinderHomeTabViewModel : ViewModel{
    let homeRepository = HomeRepositoryImpl()
    let userRepository = UserRepositoryImpl()
    let notificationsRepository = NotificationsRepositoryImpl()
    
    let onActiveMindingItemClicked = PublishRelay<String>()
    let onRequestsItemClicked = PublishRelay<String>()
    let onBookingsItemClicked = PublishRelay<String>()
    let onRecentSessionItemClicked = PublishRelay<String>()
    
    let onSeeAllBookingsClicked = PublishRelay<Void>()
    let onSeeAllRequestsClicked = PublishRelay<Void>()
    
    let activeMindingItems =  BehaviorRelay<[MindingItem]>(value: [])
    
    let requestItems = BehaviorRelay<[MindingRequestItem]>(value: [])
    
    let bookingItems = BehaviorRelay<[BookingItem]>(value: [])
    
    let recentSessionItems = BehaviorRelay<[PastWorksItem]>(value: [])
    
    let hasUnreadNotification = BehaviorRelay<Bool>(value: false)
    
    let availabilitySwitchChanged = PublishRelay<Bool>()
    
    let finderAvailableStatus: Observable<AvailableStatus?> = SessionManager.shared.finderAvailableStatusFlow
    
    let name = BehaviorRelay<String>(value: "")
    let greeting = BehaviorRelay<String>(value: "")
    
    required init() {
        super.init()
        
        notificationsRepository.getAllNotificationsFlow()
            .bind(onNext: { notificationList in
                self.hasUnreadNotification.accept(!(notificationList.filter{!($0.isSeen)}.isEmpty))
            })
            .disposed(by: disposeBag)
        
        self.refreshNotifications()
        
        self.getMindingRequests()
    }
    
    func refreshNotifications(){
        notificationsRepository.refreshNotifications()
            .subscribe(onError: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func getMindingRequests(){
        
        let firstName = SessionManager.shared.user?.fullName?.split(separator: " ").first ?? ""
        name.accept("Hello \(String(firstName))")
        
        greeting.accept(Utils.getGreetingsText())
        
        self.homeRepository.getSentMindingRequests()
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
                    onSuccess: {
                        //Minding for || Ongoing Session
                        self.activeMindingItems.accept(
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{
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
                                    location: $0.addressName ?? "",
                                    startedTime:  "Started from: \($0.entry!.clockIn?.asDateTime().asTimeString() ?? "")",
                                    isProfileVerified: $0.minder?.isProfileVerified() ?? false)
                            }
                        )
                        
                        
                        //Minding Requests
                        let requestItemsTemp = $0.filter{ mindingRequest in
                            return mindingRequest.status == .PENDING
                        }.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() })
                        
                        self.requestItems.accept(
//                            (requestItemsTemp.filter{$0.status == .PENDING} + requestItemsTemp.filter{$0.status != .PENDING})
                            requestItemsTemp.map{
                                MindingRequestItem(
                                    id: $0.id,
                                    name: $0.minder?.fullName ?? "",
                                    imageURL: $0.minder?.image ?? "",
                                    date:  $0.createdAt.asDateTime().asPreetyDateString(),
                                    requestStatus: $0.status,
                                    isProfileVerified: $0.minder?.isProfileVerified() ?? false
                                )
                            }
                        )
                        
                        
                        //Bookings
                        self.bookingItems.accept(
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry =  mindingRequest.entry else {return false}
                                return (entry.clockIn == nil) && (entry.clockOut == nil)
                            }.map{
                                BookingItem(id: $0.id,
                                            name: $0.minder?.fullName ?? "...",
                                            imageURL: $0.minder?.image ?? "",
                                            date: $0.from.asDateTime().asPreetyDateString(),
                                            timeDuration: "\($0.from.asDateTime().asTimeString()) - \($0.to.asDateTime().asTimeString())",
                                            rate: "\($0.currency.symbol) \(String(describing:$0.perHourRate))", perTime: "per hour",
                                            isProfileVerified: $0.minder?.isProfileVerified() ?? false
                                )
                            }
                        )
                        
                        //RecentSession
                        self.recentSessionItems.accept(
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
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
        self.userRepository.updateUserDetails(availableStatus : availableStatus ? AvailableStatus.AVAILABLE : AvailableStatus.NOT_AVAILABLE)
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            })
            .subscribe(onSuccess: { _ in
                SessionManager.shared.finderAvailableStatus = availableStatus ? AvailableStatus.AVAILABLE : AvailableStatus.NOT_AVAILABLE
                
            },onFailure:self.error.accept).disposed(by: disposeBag)
    
    }
    
}
