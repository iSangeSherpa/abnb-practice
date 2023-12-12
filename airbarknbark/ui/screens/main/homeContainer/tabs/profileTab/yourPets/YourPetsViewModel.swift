//
//  YourPetsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 16/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class YourPetsViewModel : ViewModel {
    let petClicked =  PublishRelay<PetDetails>()
    
    let yourPetsItems =  BehaviorRelay<[PetDetails]>(value: [])
    var changedNameMap =  [String:String]()
    
    let petsRepository = PetsRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
    
    let removePetImageButtonClicked = PublishRelay<PetDetails>()
    let newPetImageButtonClicked = PublishRelay<PetDetails>()
    
    let allBehaviours = BehaviorRelay.init(value: Config.allBehaviour)
    
    
    
    func getAllPets() {
        petsRepository
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
                self?.yourPetsItems.accept(pets)
            }, onFailure: { [weak self] err in
                self?.error.accept(err)
            }).disposed(by: disposeBag)
    }
    
    func petsAge(dateOfBirth : String?) -> String {
        guard let dob = dateOfBirth else
        {return "N/A"}
        
        let birthdayDate = dob.asDate()
        
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
        let age = calcAge.year
        
        guard let age = age else
        {return "N/A"}
        
        return String(age)
        
    }
    
    func removePet(petId: String){
        self.petsRepository.removePet(petId: petId)
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
                onSuccess: { [self] deletePetResponse in
                    self.getAllPets()
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
    }
}
