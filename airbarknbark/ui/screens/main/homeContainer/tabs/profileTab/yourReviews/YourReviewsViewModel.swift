//
//  YourReviewsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class YourReviewsViewModel :  ViewModel{
    let userRepository = UserRepositoryImpl()
    
    let reviews =  BehaviorRelay<[ReviewsItem]>(value: [])
    let homeRepository = HomeRepositoryImpl()
    
    required init() {
        super.init()
        self.getReviews()
    }
    
    func getReviews(){
        self.userRepository.getReceivedReviews()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: {
                    self.reviews.accept(
                            $0.sorted(by:{ $0.createdAt.asDateTime() > $1.createdAt.asDateTime() }).map{
                                ReviewsItem(name: $0.fromUser?.fullName ?? "", avatarImage: $0.fromUser?.image ?? "", review: $0.message, rating: "\($0.rating)",images: $0.images,to: (($0.toUser != nil) ? $0.toUser?.fullName : $0.toPet?.name) ?? "")
                            } 
                    )
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
}
