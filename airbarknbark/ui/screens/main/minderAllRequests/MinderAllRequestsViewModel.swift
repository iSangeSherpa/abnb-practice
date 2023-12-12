//
//  MinderAllRequestsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/12/2022.
//

import Foundation

import RxRelay
import RxSwift

class MinderAllRequestsViewModel : ViewModel{

    let homeRepository = HomeRepositoryImpl()
    
    let allRequestItems = BehaviorRelay<[MindingRequestItem]>(value: [])
    
    let onRequestItemClicked = PublishRelay<String>()
    
    let triggerHomeRefresh = PublishRelay<Void>()
    
    required init() {
        super.init()
        self.getAllRequests()
    }
    
    func getAllRequests(){
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
                        //Minding Requests
                       let allRequestsTemp = $0.filter{ mindingRequest in
                            return true//mindingRequest.status != "ACCEPTED"
                        }.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() })
                        
                        self.allRequestItems.accept(
                            (allRequestsTemp.filter{$0.status == .PENDING} + allRequestsTemp.filter{$0.status != .PENDING})
                                .map{
                                    MindingRequestItem(
                                        id: $0.id,
                                        name: $0.finder?.fullName ?? "",
                                        imageURL: $0.finder?.image ?? "",
                                        date:  $0.createdAt.asDateTime().asPreetyDateString(),
                                        requestStatus: $0.status,
                                        isProfileVerified: $0.finder?.activeProfile == .FINDER ? false : $0.finder?.isProfileVerified() ?? false
                                    )
                                }
                        )
                    },
                    onFailure: self.error.accept
                ).disposed(by: disposeBag)
                }
    
    
}
