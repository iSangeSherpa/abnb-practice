//
//  CreateRequestViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class CreateRequestViewModel : ViewModel{
    var minderUserId = ""
    let homeRepository = HomeRepositoryImpl()
    let petsRepository = PetsRepositoryImpl()
    let conversationRepository = ConversationRepositoryImp()
    
    let fromDate = BehaviorRelay<Date?>(value: nil)
    let toDate = BehaviorRelay<Date?>(value: nil)
    
    let fromTime = BehaviorRelay<String>(value: "")
    let toTime = BehaviorRelay<String>(value: "")
    let onRequestSuccess = PublishRelay<Void>()
    
    let perHourRate = BehaviorRelay<String>(value: "")
    let message = BehaviorRelay<String>(value: "")
    
    
    let petClicked =  PublishRelay<Selectable<Pet>>()
    
    let petItems = BehaviorRelay<[Selectable<Pet>]>(value: [])
    
    required init() {
        super.init()
        
        petClicked.withLatestFrom(petItems) { item, items in
            items.map { it in
                it.item == item.item ? it.copy(isSelected: !it.isSelected) : it
            }
        }.bind(to: petItems)
            .disposed(by: disposeBag)
        
        self.getAllPets()
    }
    
    func getAllPets(){
        self.petsRepository
            .getAllPets()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(onSuccess: { [weak self] pets in
                self?.petItems.accept(pets.map{Selectable(item: $0, isSelected: false)})
            }, onFailure: { [weak self] err in
                self?.error.accept(err)
            }).disposed(by: disposeBag)
    }
    
    func createRequest(){
        if(!validationSuccess()){
            return
        }
        
        homeRepository.createRequest(
            minderUserId : self.minderUserId,
            from : (fromDate.value?.asDateTimeString())!,
            to : (toDate.value?.asDateTimeString())!,
            
            perHourRate : Float(self.perHourRate.value)!,
            message : self.message.value,
            currencyId : "clb31ohgk00002j44zruoa2rn", //TODO:
            pets: petItems.value.filter{$0.isSelected}.map{$0.item}
        ).observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { response in
                    self.onRequestSuccess.accept(Void())
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func validationSuccess()->Bool{
        if(fromDate.value == nil){
            self.alert("Invalid Date")
            return false
        }
        if(toDate.value == nil){
            self.alert("Invalid Date")
            return false
        }
        if(perHourRate.value.isEmpty){
            self.alert("Invalid per hour rate")
            return false
        }
        if(petItems.value.filter{$0.isSelected}.isEmpty){
            self.alert("Please select pets")
            return false
        }
        return true
    }
}
