//
//  EditProfileViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 17/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class EditProfileViewModel : ViewModel{
    var fromLogin = false
    
    let userRepository = UserRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
    let petsRepository = PetsRepositoryImpl()
    
    let userImage = BehaviorRelay<String>(value: "")
    let newProfileImage = BehaviorRelay<UIImage?>(value: nil)
    let fullName = BehaviorRelay<String>(value: "")
    let shortBio = BehaviorRelay<String>(value: "")
    let fetchedShortBio = BehaviorRelay<String>(value: "")
    let pets = BehaviorRelay<[PetDetails]>(value:[]);
    
    let newPetButtonClciked = PublishRelay<Void>()
    let removePetButtonClicked = PublishRelay<String>()
    
    let address = BehaviorRelay<AddressDetails?>(value: nil)
    let dateOfBirth = BehaviorRelay<Date?>(value: nil)
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    let contactNumber = BehaviorRelay<String?>(value: "")
    let emergencyContact = BehaviorRelay<String?>(value: "")
        
    let continueButtonClicked = PublishRelay<Void>()
    let rate =  BehaviorRelay<String>(value: "")
    let yearsOfExpereince =  BehaviorRelay<String>(value: "")
    let noExperienceCheckbox =  BehaviorRelay<Bool>(value: false)
    let available =  BehaviorRelay<Bool?>(value: nil)
    let traveling =  BehaviorRelay<Bool>(value: false)
   
    let vehicles =  BehaviorRelay<[VehicleDetails]>(value: [])
    let removeVehicleClicked =  PublishRelay<String>()
    let newVehicleClicked =  PublishRelay<Void>()
    let vehicleClicked =  PublishRelay<VehicleDetails>()
    
    let dayClicked =  PublishRelay<Selectable<String>>()
    let availableDays = BehaviorRelay<[Selectable<String>]>(value: daysOfWeek.map { Selectable(item: $0, isSelected: false) } )
    let allWorkingHours = BehaviorRelay<[DayAvilability]>(value: daysOfWeek.map {DayAvilability(day: $0, from: Date.now, to: Date.now)})
    
    let gender = BehaviorRelay<Gender?>(value: nil)
    
    let petBehaviours = BehaviorRelay<[Selectable<String>]>(value: Config.allBehaviour.map { Selectable(item: $0, isSelected: false) })
    let petBehaviourClicked = PublishRelay<(Selectable<String>)>()
    let customPetBehaviour = BehaviorRelay<String>(value: "")
    let dogSizePreference = BehaviorRelay<Set<PetSizePreferences>>(value:[])
    
    let selectedBreed = BehaviorRelay<Breed?>(value:nil)
    
    lazy var workingHours : Observable<[DayAvilability]> =  Observable.combineLatest(availableDays, allWorkingHours){ days, hours in
        
        return hours.filter { it in
            days.contains { day in
                day.item.uppercased() == it.day.uppercased() && day.isSelected
            }
        }
        
    }
    
    required init() {
        super.init()
        
        removePetButtonClicked.bind{[self] petId in
            self.removePet(petId: petId)
        }.disposed(by: disposeBag)
        
        removeVehicleClicked.bind{
            [self] vehicleId in
            self.removeVehicle(vehicleId : vehicleId)
        }.disposed(by: disposeBag)
        
        dayClicked.withLatestFrom(availableDays) { item, items in
            items.map { it in
                it.item == item.item ? it.copy(isSelected: !it.isSelected) : it
            }
        }.bind(to: availableDays)
            .disposed(by: disposeBag)
        
        petBehaviourClicked.withLatestFrom(petBehaviours){ item, items in
            items.map { it in
                it.item == item.item ? it.copy(isSelected: !it.isSelected) : it.copy(isSelected: it.isSelected)
            }
        }.bind(to: petBehaviours)
            .disposed(by: disposeBag)
        
        loadUserDetails()
        loadAllPets()
        loadAddress()
        loadMinderProfileDetails()
        
    }
    
    func updateFrom(dateOfWeek:String, date:Date){
        
        let newValues = allWorkingHours.value.map { item in
            item.day == dateOfWeek ? item.copy(from: date) : item
        }
        allWorkingHours.accept(newValues)
    }
    
    func updateTo(dateOfWeek:String, date:Date){
        
        let newValues = allWorkingHours.value.map { item in
            item.day == dateOfWeek ? item.copy(to: date) : item
        }
        allWorkingHours.accept(newValues)
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
    
    func removeVehicle(vehicleId: String){
        self.userRepository.removeVehicle(vehicleId: vehicleId)
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
                onSuccess: { [self] deletedVehicle in
                    self.vehicles.accept(vehicles.value.filter { vehicle in
                        vehicle.id != deletedVehicle.id
                    })
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func updateAddress(addressDetail : Address){
        userRepository.updateAddress(addressDetail: addressDetail)
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
                    self?.address.accept(it)
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func removeAddress() {
        userRepository.removeAddress()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(onSuccess: { [weak self] it in
                let userId = SessionManager.shared.userId ?? ""
                self?.address.accept(AddressDetails(userId: userId, name: "", longitude: -1, latitude: -1))
            },
            onFailure : self.error.accept
            ).disposed(by: disposeBag)
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
                    self?.userImage.accept(it.image ?? "")
                    self?.dateOfBirth.accept(it.dob?.asDate())
                    self?.contactNumber.accept(it.phoneNumber ?? "")
                    self?.showMyNumber.accept(!(it.hidePhoneNumber ?? false) )
                    self?.emergencyContact.accept(it.emergencyPhoneNumber ?? "")
                    self?.gender.accept(it.gender)
                    
                    self?.traveling.accept(it.minderProfile?.traveling ?? false)
                    self?.vehicles.accept(it.minderProfile?.vehicles ?? [])
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
    
    func loadAddress(){
        userRepository.getAddress()
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
                    self?.address.accept(it)
                }
//                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func loadMinderProfileDetails(){
        userRepository.getMinderProfileDetails()
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
                    //MARK: Update Minder Profile Section
                    self?.available.accept(it.getAvailabilityStatus())
                    
                    let selectedDays : [MinderAvailability] = it.minderAvailability!.filter{ workingDays in
                        workingDays.from != "00:00" && workingDays.to != "00:00"
                    }
                    
                    self?.availableDays.accept( (self?.availableDays.value.map{ selectableString in
                        let isSelected = selectedDays.map{$0.dayOfWeek.uppercased()}.contains(selectableString.item.uppercased())
                        return selectableString.copy(isSelected:isSelected)
                    })!)
                    
                    if(it.minderAvailability?.count ?? 0 > 0){
                        self?.allWorkingHours.accept(it.minderAvailability!.map{minderAvailability in
                            
                            let dayAvailability = DayAvilability(
                                day: minderAvailability.dayOfWeek,
                                from: minderAvailability.from.asTime24Hr(),
                                to: minderAvailability.to.asTime24Hr()
                            )
                            return dayAvailability
                        })
                    }
                    self?.rate.accept((it.perHourRate == nil ) ? "" : String(describing: it.perHourRate!))
                    self?.yearsOfExpereince.accept((it.yearsOfExperience == nil) ? "" : String(describing: it.yearsOfExperience!))
                    
                    self?.dogSizePreference.accept(Set(it.petSizePreferences))
                    self?.selectedBreed.accept(it.breedPreferences?.first)
                    
                    self?.petBehaviours.accept((self?.petBehaviours.value.map{
                        $0.copy(isSelected: it.petBehaviorPreferences.contains($0.item))
                    })!)
                }
//                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func updatePetSize(petSize : PetSizePreferences){
        if(self.dogSizePreference.value.contains(petSize)){
            self.dogSizePreference.accept(self.dogSizePreference.value.filter{$0 != petSize})
        }else{
            var updatedSet = self.dogSizePreference.value
            updatedSet.insert(petSize)
            self.dogSizePreference.accept(updatedSet)
        }
    }
    
    func validationSuccess()->Bool{
    
        if(fullName.value.isEmpty){
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
        
        if(SessionManager.shared.userType != .FINDER){
            if(traveling.value && vehicles.value.isEmpty){
                self.alert("Please add vehicle")
                return false
            }
            
            if(available.value == nil){
                self.alert(.MinderProfileSetup.invalidAvailability)
                return false
            }

            else if(rate.value.isEmpty){
                self.alert(.MinderProfileSetup.invalidRate)
                return false
            }
            else if(yearsOfExpereince.value.isEmpty && noExperienceCheckbox.value){
                self.alert(.MinderProfileSetup.invalidExperience)
                return false
            }
            else if(dogSizePreference.value.isEmpty ){
                self.alert(.MinderProfileSetup.invalidDogSizePreference)
                return false
            }
            else if(selectedBreed.value == nil){
                self.alert(.MinderProfileSetup.invalidBreedPreference)
                return false
            }
            else if(petBehaviours.value.filter{$0.isSelected}.isEmpty && customPetBehaviour.value.isEmpty ){
                self.alert(.MinderProfileSetup.invalidPetBehaviour)
                return false
            }
            
            
        }
        
       
        return true
    }
    
    
    func saveChanges(){
        if(!validationSuccess()){
            return
        }
        
        func getUpdateProfileObservable(imagePath:String? = nil) -> Single<UserDetails>{
            return self.userRepository.updateUserDetails(
                fullName: self.fullName.value,
                image: (imagePath != nil) ? imagePath : self.userImage.value,
                shortBio: self.shortBio.value,
                activeProfile: SessionManager.shared.userType?.rawValue,
                dob: self.dateOfBirth.value?.asDateString(),
                phoneNumber: (self.contactNumber.value ?? "").isEmpty ? nil : self.contactNumber.value,
                showMyNumber: self.showMyNumber.value,
                emergencyContact: (self.emergencyContact.value ?? "").isEmpty ? nil : self.emergencyContact.value,
                gender: self.gender.value?.rawValue
            )
        }
        //MARK: Update User Details
        let updateProfileObservable = getUpdateProfileObservable()
        
        let updateProfileWithImageObservable = newProfileImage.value == nil ? updateProfileObservable : self.utilRepository.uploadFile(fileData: (newProfileImage.value?.jpeg(.high))!,fileName: "profile.jpeg",type: .PROFILE_PICTURE).flatMap{ image in
            getUpdateProfileObservable(imagePath: image.path)
        }
        
        if(SessionManager.shared.userType == .FINDER){
            updateProfileWithImageObservable.do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                })
            .subscribe(onSuccess: {
                response in
                SessionManager.shared.user = response
                self.alerts.accept(.success(.EditProfile.savedSuccessfully))
            },onFailure:self.error.accept).disposed(by: disposeBag)
                
            return
        }
        
        let minderProfileRequestParam = MinderProfileRequest(
            travelling: self.traveling.value,
            availableStatus: available.value! ? String(describing:AvailableStatus.AVAILABLE) : String(describing: AvailableStatus.NOT_AVAILABLE),
            perHourRate: ((rate.value) as NSString).floatValue,
            currencyId: "clb31ohgk00002j44zruoa2rn",
            yearsOfExperience: (yearsOfExpereince.value as NSString).floatValue,
            petSizePreferences: dogSizePreference.value.map{$0.rawValue},
            petBehaviorPreferences: petBehaviours.value.filter{$0.isSelected}.map{$0.item},
            breedPreferences: [["id":String(selectedBreed.value!.id)]],
            
            minderAvailability: allWorkingHours.value.map{ workingHours in
                let isDaySelected = (availableDays.value.filter{
                    $0.item.caseInsensitiveCompare(workingHours.day) == .orderedSame
                }.first.map{$0.isSelected})!
                return [
                    "from" :  isDaySelected ? workingHours.from.as24HourTimeString() : "00:00",
                    "to" : isDaySelected ? workingHours.to.as24HourTimeString() : "00:00",
                    "dayOfWeek" : workingHours.day.uppercased()
                ]
            }
        )
        
        //MARK: Update Minder Profile Details
        let updateMinderProfileObservable = self.userRepository.updateMinderProfile(minderProfileRequestParams: minderProfileRequestParam.asParameters())
        
        Single.zip(updateProfileWithImageObservable,updateMinderProfileObservable).observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                })
            .subscribe(onSuccess: {
                response in
                SessionManager.shared.user = response.0
                self.alerts.accept(.success(.EditProfile.savedSuccessfully))
            },onFailure:self.error.accept).disposed(by: disposeBag)
    }
}
