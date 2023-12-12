//
//  RateFinderViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import RxRelay
import Differentiator
import RxSwift

struct PetReviewModel{
    var id : String = UUID().uuidString
    var petName : String
    var petImage : String
    var petRatings : Int
    var petReviews : String
    
    static func == (lhs: PetReviewModel, rhs: PetReviewModel) -> Bool {
        return lhs.id  == rhs.id
    }
    
}
class RateFinderViewModel : ViewModel{
    var requestId = ""
    var finderUserId  = ""
    var pets : [PetDetails] = []
    
    let homeRepository = HomeRepositoryImpl()

    let finderStarRatings = BehaviorRelay<Int>(value: -1)
    let finderReview = BehaviorRelay<String>(value: "")
    
    let petImage = BehaviorRelay<String>(value: "")
    let petStarRating = BehaviorRelay<Int>(value: -1)
    let petReview = BehaviorRelay<String>(value: "")
    
    let petStarRatingTemp = BehaviorRelay<Int>(value: -1)
    let petReviewTemp = BehaviorRelay<String>(value: "")
    
    let onReviewSubmitted = PublishRelay<Void>()
    
    let petsReviews = BehaviorRelay<[Selectable<PetReviewModel>]>(value: [])
    
    let onPetClicked = PublishRelay<PetReviewModel>()
    
    required init() {
        super.init()
        
        onPetClicked.withLatestFrom(petsReviews) { item, items in
            items.map { it in
                it.item == item ? it.copy(isSelected: true) : it.copy(isSelected: false)
            }
        }.bind(to: petsReviews)
            .disposed(by: disposeBag)
        
        onPetClicked.bind{ item in
            guard let selectedPet = self.petsReviews.value.filter({$0.isSelected}).first else {return}
            self.petReviewTemp.accept(selectedPet.item.petReviews)
            self.petStarRatingTemp.accept(selectedPet.item.petRatings)
            
        }.disposed(by: disposeBag)
        
        petReview.bind{
            guard var selectedPet = self.petsReviews.value.filter({$0.isSelected}).first else {return}
            selectedPet.item.petReviews = $0
            self.updatedSelectedPetReview(petReview: selectedPet)
        }.disposed(by: disposeBag)
        
        petStarRating.bind{
            guard var selectedPet = self.petsReviews.value.filter({$0.isSelected}).first else {return}
            selectedPet.item.petRatings = $0
            self.updatedSelectedPetReview(petReview: selectedPet)
        }.disposed(by: disposeBag)
        
        
    }
    
    func initPets(){
        self.petsReviews.accept(
            self.pets.enumerated().map{ (index, pet) in
                Selectable(
                    item:
                        PetReviewModel(
                            id: pet.id,
                            petName: pet.name,
                            petImage: pet.images.first ?? "",
                            petRatings: -1,
                            petReviews: ""
                        ),
                    isSelected: index == 0
                )
            }
        )
    }
    
    
    func updatedSelectedPetReview(petReview : Selectable<PetReviewModel>){
        Observable.just(petReview).withLatestFrom(petsReviews) { item, items in
            items.map { it in
                (it.item == item.item) ? petReview : it
            }
        }.bind(to: petsReviews)
            .disposed(by: disposeBag)
    }
    
    
    func submitReview(){
        if(!validationSuccess()){
            return
        }
        var postReviewsObservable  = self.petsReviews.value
            .map { selectable in
                self.homeRepository.postPetReview(requestId: self.requestId, toPetId: selectable.item.id, rating: selectable.item.petRatings, message: selectable.item.petReviews, images: [])
            }
        
        postReviewsObservable.append(
            self.homeRepository.postUserReview(requestId: self.requestId, toUserId: self.finderUserId, rating: self.finderStarRatings.value, message: self.finderReview.value, images: [])
        )
        
            Single.zip(postReviewsObservable)
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
    
    func validationSuccess()->Bool{
        if(!(self.finderStarRatings.value>0)){
            self.alert(.RatingsAndReviews.invalidFinderRatings)
            return false
        }
        if(self.finderReview.value.isEmpty){
            self.alert(.RatingsAndReviews.invalidReviews)
            return false
        }
        if(self.petsReviews.value.filter{
            $0.item.petReviews.isEmpty || !($0.item.petRatings>0)
        }.count>0){
            self.alert(.RatingsAndReviews.invalidPetReviews)
            return false
        }
        return true
    }
    
}
