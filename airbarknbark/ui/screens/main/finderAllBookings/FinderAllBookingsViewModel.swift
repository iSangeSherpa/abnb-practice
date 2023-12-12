//
//  HomeTabViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxRelay
import RxSwift

class FinderAllBookingsViewModel : ViewModel{
    
    let homeRepository = HomeRepositoryImpl()
    
    let allBookingItems = BehaviorRelay<[BookingItem]>(value: [])
    
    let onBookingsItemClicked = PublishRelay<String>()
    
    let triggerHomeRefresh = PublishRelay<Void>()
    
    required init() {
        super.init()
        self.getAllBookings()
    }
    
    func getAllBookings(){
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
                        //Bookings
                        self.allBookingItems.accept(
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
                                guard mindingRequest.status == .ACCEPTED else {return false}
                                guard let entry =  mindingRequest.entry else {return false}
                                return (entry.clockIn == nil) && (entry.clockOut == nil)
                            }.map{
                                BookingItem(id: $0.id,
                                            name: $0.minder?.fullName ?? "...",
                                            imageURL: $0.minder?.image ?? "",
                                            date: $0.from.asDateTime().asPreetyDateString(),
                                            timeDuration: "\($0.from.asDateTime().asTimeString()) - \($0.to.asDateTime().asTimeString())" ,
                                            rate: "\($0.currency.symbol) \(String(describing:$0.perHourRate))", perTime: "per hour",
                                            isProfileVerified: $0.minder?.activeProfile == .FINDER ? false : $0.minder?.isProfileVerified() ?? false
                                )
                            }
                        )
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
    }
}
