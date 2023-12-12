//
//  SetupProfileViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 16/09/2022.
//

import Foundation
import RxSwift
import RxRelay


class SetupProfileViewModel : ViewModel {
    var forIncompleteProfile = true
    
    let userRepository = UserRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
    let petsRepository = PetsRepositoryImpl()
    
    let fullName = BehaviorRelay<String>(value: "")
    let shortBio = BehaviorRelay<String>(value: "")
    let fetchedShortBio = BehaviorRelay<String>(value: "")
    
    let userProfileImage  = BehaviorRelay<UIImage?>(value:nil)
    let userProfileImageURL  = BehaviorRelay<String?>(value:nil)
    let pets = BehaviorRelay<[PetDetails]>(value:[]);
    
    let newPetButtonClciked = PublishRelay<Void>()
    let removePetButtonClicked = PublishRelay<String>()
    
    let userType = PublishRelay<ActiveProfile>()
    let gender = BehaviorRelay<Gender?>(value: nil)
    
    let updateDetailsAction = PublishRelay<Bool>()
    
    required init() {
        super.init()
        
        removePetButtonClicked.bind{ petIdToRemove in
            self.removePet(petId: petIdToRemove)
        }
        .disposed(by: disposeBag)
    }
    
    func updateUserDetails(userType: ActiveProfile){
        SessionManager.shared.userType = userType
        if(!validationSuccess()){
            return
        }
        if(userProfileImage.value?.pngData() == nil){
            self.saveUserDetails(imageURL: userProfileImageURL.value!,userType: userType)
            return
        }
        self.utilRepository.uploadFile(fileData: (userProfileImage.value?.jpeg(.high))!,fileName: "profile.jpeg",type: .PROFILE_PICTURE)
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
                onSuccess:{ [self]
                    fileUploadResponse in
                    self.saveUserDetails(imageURL:fileUploadResponse.path,userType: userType)
                    
                }, onFailure: self.error.accept).disposed(by: disposeBag)
    }
    
    
    func saveUserDetails(imageURL: String,userType: ActiveProfile){
        self.userRepository.updateUserDetails(
            fullName: fullName.value,
            image:imageURL,
            shortBio: shortBio.value,
            activeProfile: userType.rawValue,
            gender: gender.value?.rawValue
        )
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            })
        .subscribe(
            onSuccess: { updateUserDetailResponse in
                self.updateDetailsAction.accept(true)
                
            },
            onFailure:self.error.accept
        ).disposed(by: disposeBag)
            
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
                    self.pets.accept(pets.value.filter { petItem in
                        petId != petItem.id
                    })
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func validationSuccess()->Bool{
        if(userProfileImage.value == nil && userProfileImageURL.value == nil){
            self.alert(.SetupProfile.invalidProfilePhoto)
            return false
        }
        else if(fullName.value.isEmpty){
            self.alert(.SetupProfile.invalidFullName)
            return false
        }
        else if(shortBio.value.isEmpty){
            self.alert(.SetupProfile.invalidShortbio)
            return false
        }
        else if(gender.value == nil){
            self.alert(.SetupProfile.invalidGender)
            return false
        }
        return true
    }
    
    func loadData(){
        loadUserDetails()
        loadAllPets()
    }
    
    func loadUserDetails(){
        userRepository.getUserDetails()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { [weak self] it in
                    self?.fetchedShortBio.accept(it.bio ?? "")
                    self?.fullName.accept(it.fullName ?? "")
                    self?.userProfileImageURL.accept(it.image)
                    self?.gender.accept(it.gender)
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func loadAllPets(){
        petsRepository.getAllPets()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { [weak self] it in
                    self?.pets.accept(it)
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
}
