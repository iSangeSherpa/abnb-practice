//
//  MinderHomeTabViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import RxRelay
import RxSwift
import Alamofire

class MinderHomeTabViewModel : ViewModel{
    let homeRepository = HomeRepositoryImpl()
    let userRepository = UserRepositoryImpl()
    let notificationsRepository = NotificationsRepositoryImpl()
    
    let minderAvailableStatus: Observable<MinderAvailableStatus?> = SessionManager.shared.availableStatusFlow
    
    let onActiveMindingItemClicked = PublishRelay<String>()
    let onRequestsItemClicked = PublishRelay<String>()
    let onBookingsItemClicked = PublishRelay<String>()
    
    let onSeeAllBookingsClicked = PublishRelay<Void>()
    let onSeeAllRequestsClicked = PublishRelay<Void>()
    
    let availabilitySwitchChanged = PublishRelay<Bool>()
    
    let activeMindingItems =  BehaviorRelay<[MindingItem]>(value: [])
    
    let requestItems = BehaviorRelay<[MindingRequestItem]>(value: [])
    
    let bookingItems = BehaviorRelay<[BookingItem]>(value: [])
    
    let hasUnreadNotification = BehaviorRelay<Bool>(value: false)
    
    let name = BehaviorRelay<String>(value: "")
    
    let greeting = BehaviorRelay<String>(value: "")
    
    required init() {
        super.init()
        
        notificationsRepository.getAllNotificationsFlow()
            .bind(onNext: { notificationList in
                self.hasUnreadNotification.accept(!(notificationList.filter{!($0.isSeen)}.isEmpty))
            }).disposed(by: disposeBag)
        
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
        
        self.homeRepository.getReceivedMindingRequests()
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
                                    name: $0.finder?.fullName ?? "",
                                    imageURL: $0.finder?.image ?? "",
                                    leftTime: timeLeftValue,
                                    location: $0.addressName ?? "-",
                                    startedTime:  "Started from: \($0.entry!.clockIn?.asDateTime().asTimeString() ?? "")",
                                    isProfileVerified: $0.finder?.isProfileVerified() ?? false
                                )
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
                                    name: $0.finder?.fullName ?? "",
                                    imageURL: $0.finder?.image ?? "",
                                    date: $0.createdAt.asDateTime().asPreetyDateString(),
                                    requestStatus: $0.status,
                                    isProfileVerified: $0.finder?.isProfileVerified() ?? false
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
                                            name: $0.finder?.fullName ?? "...",
                                            imageURL: $0.finder?.image ?? "",
                                            date: $0.from.asDateTime().asPreetyDateString(),
                                            timeDuration: "\($0.from.asDateTime().asTimeString()) - \($0.to.asDateTime().asTimeString())" ,
                                            rate: String(describing:$0.perHourRate), perTime: "per hour",
                                            isProfileVerified: $0.finder?.isProfileVerified() ?? false
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

