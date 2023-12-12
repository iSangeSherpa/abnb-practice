//
//  BreedRepository.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 23/11/2022.
//

import Foundation
import RxSwift
import Alamofire
import RealmSwift


protocol PetsRepository {
    func createNewPet(petDetails: PetLocal) -> Single<PetDetails>
    func removePet(petId: String) -> Single<IdResponse>
    func getAllPets() -> Single<[Pet]>
    func getAllPets() -> Single<[PetDetails]>
    func updatePet(petLocal: PetLocal) -> Single<PetDetails>
}

class PetsRepositoryImpl : PetsRepository {
    
    private let realm = try! Realm()
    private  let userId = SessionManager.shared.userId ?? ""
    
    func getAllPets() -> Single<[Pet]> {
        return ApiService.getAllPets(userId: userId).map { $0.data }
    }
    
    func createNewPet(petDetails: PetLocal) -> Single<PetDetails> {
        
        let params : Parameters = [
            "name": petDetails.name,
            "about": petDetails.about,
            "dob":petDetails.dateOfBirth,
            "images": petDetails.imagesString ?? [],
            "breedId": petDetails.breed?.id ?? "",
            "immunizationStatus": petDetails.immunizationStatus,
            "behavior": petDetails.behaviour
        ]
        
        return  ApiService.createNewPet(userId: userId, param: params).map{
            $0.data
        }
    }
    
    func removePet(petId: String) -> Single<IdResponse>{
        return ApiService.deletePet(userId: userId, petId: petId).map { $0.data }
    }
    
    func refreshBreeds() -> Completable {
        return ApiService.getAlBreeds().map{
            $0.data.map {
                $0.toDomain()
            }
        }.do { [self] items in
            try! realm.write { [self] in
                self.realm.add(items, update: .modified)
             }
        }.asCompletable()
    }
    
    func getAllBreedsFlow() -> Observable<[Breed]> {
        return Observable.array(from: realm.objects(Breed.self))
    }
    
    func addBreed(name:String) -> Single<Breed> {
        return ApiService.createNewBreed(param: ["name":name])
            .map{ $0.data.toDomain() }
            .do { [self]  it in
                try! realm.write { [self] in
                    self.realm.add(it, update: .modified)
                 }
            }
    }
    
    func getAllPets() ->Single<[PetDetails]>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getAllPets(userId: userId).map { $0.data }
    }
    
    func updatePet(petLocal: PetLocal ) ->Single<PetDetails>{
        let params : Parameters = [
            "name": petLocal.name,
            "about": petLocal.about,
            "dob": petLocal.dateOfBirth,
            "images": petLocal.imagesString ?? [],
            "breedId": petLocal.breed?.id ?? "",
            "immunizationStatus": petLocal.immunizationStatus,
            "behavior": petLocal.behaviour
        ]
        
        return  ApiService.updatePet(userId: userId,petId: petLocal.id, param: params).map{
            $0.data
        }
    }
    
}
