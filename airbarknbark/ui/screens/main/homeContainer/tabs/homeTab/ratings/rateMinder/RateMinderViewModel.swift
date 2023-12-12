//
//  RateMinderViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import RxRelay
import RxSwift

class RateMinderViewModel : ViewModel{
    var requestId = ""
    var minderUserId  = ""
    
    let homeRepository = HomeRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
    
    let starRatings = BehaviorRelay<Int>(value: -1)
    let review = BehaviorRelay<String>(value: "")
    
    let images =  BehaviorRelay<[UIImage]>(value: [])
    let newImageButtonClciked = PublishRelay<Void>()
    let removeImageButtonClick = PublishRelay<UIImage>()
    let onReviewSubmitted = PublishRelay<Void>()
    
    required init() {
        super.init()
        removeImageButtonClick.withLatestFrom(images){ (toRemove, all)  in
            all.filter {
                $0 != toRemove
            }
        }
        .bind(to: images)
        .disposed(by: disposeBag)
    }
    
    
    func submitReview(){
        let imagesObservables  =  images.value
            .map { image in
                utilRepository.uploadFile(fileData: (image.jpeg(.high))!, fileName: "img.jpeg", type: .OTHER)
            }
        
        Single.zip(imagesObservables) { it  in
            it.map { $0.path }
        }
        .flatMap{ (images:[String])-> Single<IdResponse> in
            self.homeRepository.postUserReview(requestId: self.requestId, toUserId: self.minderUserId, rating: self.starRatings.value, message: self.review.value, images: images)
        }
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose:{ [weak self] in
                self?.loading.accept(false)
            }
        ).subscribe(
            onSuccess: {  [weak self] vehicleDetails in
                self?.onReviewSubmitted.accept(Void())
            },
            onFailure: self.error.accept
        ).disposed(by: disposeBag)
    }

}
