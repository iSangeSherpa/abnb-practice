//
//  RecentSessionsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 26/12/2022.
//

import Foundation
import RxRelay
import RxSwift

class RecentSessionViewModel : ViewModel{
    let homeRepository = HomeRepositoryImpl()
    
    let recentSessions =  BehaviorRelay<[PastWorksItem]>(value: [])
    
    required init() {
        super.init()
        self.getPastWorks()
    }
    
    func getPastWorks(){
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
                    self.recentSessions.accept(
                        $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).filter{ mindingRequest in
                            guard mindingRequest.status == .ACCEPTED else {return false}
                            guard let entry =  mindingRequest.entry else {return false}
                            return (entry.clockIn != nil) && (entry.clockOut != nil)
                        }.map{
                            
                            let totalTime = DateUtils.getElapsedTime(from: $0.from.asDateTime(),
                                                                     to: $0.to.asDateTime())
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
    
}
