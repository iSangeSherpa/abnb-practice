//
//  NewPetViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 21/09/2022.
//

import Foundation
import RxRelay
import UIKit
import RxSwift


class NewPetViewModel : ViewModel{
    var pet : PetDetails? = nil
    let petsRepository = PetsRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
    
    let name = BehaviorRelay(value: "")
    let about = BehaviorRelay(value: "")
    let fetchedAbout = BehaviorRelay(value: "")
    let dateOfBirth  =  BehaviorRelay<String?>(value: nil)
    let breed =  BehaviorRelay<Breed?>(value: nil)
    let immunizationStatus =  BehaviorRelay<Bool?>(value: nil)
    let behaviour =  BehaviorRelay<String?>(value: nil)
    let images =  BehaviorRelay<[ImageOrURL]>(value: [])
    
    let newImageButtonClciked = PublishRelay<Void>()

    let onNewPet = PublishRelay<PetDetails>()
    let doneButtonClick = PublishRelay<Void>()
    let removeImageButtonClick = PublishRelay<ImageOrURL>()

    let allBehaviours = BehaviorRelay.init(value: Config.allBehaviour)
   
    required init() {
        super.init()
                
        onNewPet.bind { [self] it in
            dismissBy.accept(Void())
        }.disposed(by: disposeBag)
        
        doneButtonClick
            .bind { [self] it in
                let petDetails = PetLocal(
                    id : pet?.id ?? "",
                    name: name.value,
                    dateOfBirth: (dateOfBirth.value ?? Date.now.asYearString()),
                    about : about.value,
                    breed: breed.value,
                    immunizationStatus: immunizationStatus.value ?? false,
                    behaviour: behaviour.value ?? "",
                    images:  []
                )
                createOrUpdate(petLocal: petDetails, update: pet != nil)
            }
            .disposed(by: disposeBag)
        removeImageButtonClick.withLatestFrom(images){ (toRemove, all)  in
            all.filter {
                !($0 == toRemove)
            }
        }
        .bind(to: images)
        .disposed(by: disposeBag)
        
    }
    
    func loadPetDetails(){
        if(self.pet != nil){
            self.name.accept(pet?.name ?? "")
            self.fetchedAbout.accept(pet?.about ?? "")
            self.dateOfBirth.accept(((pet?.dob.count ?? 0) > 4) ? pet?.dob[0..<4] : pet?.dob)
            self.breed.accept(pet?.breed)
            self.immunizationStatus.accept(pet?.immunizationStatus)
            self.behaviour.accept(pet?.behavior)
            self.images.accept(pet?.images.map{
                ImageOrURL(image: nil, imageURL: $0)
            } ?? [])
        }
    }
    

    func createOrUpdate(petLocal : PetLocal, update : Bool = true){
        if(!validationSuccess()){
            return
        }
        
        let imagesObservables  =  images.value.filter{$0.image != nil}
            .map { image in
                utilRepository.uploadFile(fileData: image.image!.jpeg(.high)!, fileName: "img.jpeg", type: .PETS)
            }
        
        Single.zip(imagesObservables) { it  in
            it.map { $0.path }
        }
        .flatMap{ (images:[String])-> Single<PetDetails> in
            var petDetail = petLocal
            petDetail.imagesString = images +  self.images.value.filter{$0.imageURL != nil}.map{$0.imageURL!}
            if(update){
                return self.petsRepository.updatePet(petLocal: petDetail)
            }else{
                return self.petsRepository.createNewPet(petDetails: petDetail)
            }
        }
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
            self?.loading.accept(true)
            },
            onDispose:{ [weak self] in
                self?.loading.accept(false)
            }
        )
        .subscribe(
            onSuccess: {  [weak self] petResponse in
                var newPet = petResponse
                newPet.breed = petLocal.breed
                self?.onNewPet.accept(newPet)
            },
            onFailure: self.error.accept
        ).disposed(by: disposeBag)
    }
    
    
    func validationSuccess()->Bool{
        if(name.value.isEmpty){
            self.alert(.NewPet.invalidPetName)
            return false
        }
        
        else if(dateOfBirth.value == nil){
            self.alert(.NewPet.invalidDob)
            return false
        }
        else if(breed.value == nil) {
            self.alert(.NewPet.invalidBreedType)
            return false
        }
        else if(immunizationStatus.value == nil){
            self.alert(.NewPet.invalidImmunizationStatus)
            return false
        }
        else if(behaviour.value == nil){
            self.alert(.NewPet.invalidPetBehaviour)
            return false
        }
        else if(images.value.count == 0){
            self.alert(.NewPet.invalidPetPhoto)
            return false
        }
        return true
    }
    
    func allYears()->[String]{
        let curentDate = Calendar.current.component(.year, from: Date())
        
        return ((curentDate - 100)...curentDate).map{
            String($0)
        }.reversed()
    }
}
