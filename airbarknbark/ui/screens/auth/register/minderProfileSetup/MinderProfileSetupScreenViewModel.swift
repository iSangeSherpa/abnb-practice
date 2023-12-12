//
//  RegisterVerificationScreenViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 27/09/2022.
//

import Foundation
import RxRelay
import RxSwift
import Alamofire

enum DogSizePreference{
    case small
    case medium
    case large
}

class MinderProfileSetupScreenViewModel : ViewModel{
    var forIncompleteProfile = false
    var fromProfile = false
    var isTravelling = false
    let userRepository = UserRepositoryImpl()
    let petsRepository = PetsRepositoryImpl()
        
    let continueButtonClicked = PublishRelay<Void>()
    let rate =  BehaviorRelay<String>(value: "")
    let yearsOfExpereince =  BehaviorRelay<String>(value: "")
    let noExperienceCheckbox =  BehaviorRelay<Bool>(value: false)
    let available =  BehaviorRelay<Bool?>(value: nil)
    let dayClicked =  PublishRelay<Selectable<String>>()
    let availableDays = BehaviorRelay<[Selectable<String>]>(value: daysOfWeek.map { Selectable(item: $0, isSelected: false) } )
    let allWorkingHours = BehaviorRelay<[DayAvilability]>(value: daysOfWeek.map {DayAvilability(day: $0, from: Date.now, to: Date.now)})
    
    let petBehaviours = BehaviorRelay<[Selectable<String>]>(value: Config.allBehaviour.map { Selectable(item: $0, isSelected: false) })
    let petBehaviourClicked = PublishRelay<(Selectable<String>)>()
    let customPetBehaviour = BehaviorRelay<String>(value: "")
    let dogSizePreference = BehaviorRelay<Set<PetSizePreferences>>(value: [])
    let hasLegalDocuments = BehaviorRelay<Bool>(value: false)
    
    let selectedBreed = BehaviorRelay<Breed?>(value:nil)
    
    lazy var workingHours : Observable<[DayAvilability]> =  Observable.combineLatest(availableDays, allWorkingHours){ days, hours in
        
        return hours.filter { it in
            days.contains { day in
                day.item.uppercased() == it.day.uppercased() && day.isSelected
            }
        }
    }
    let acceptTerms = BehaviorRelay<Bool>(value: false)
    
    let onUpdateMinderProfile = PublishRelay<Bool>()
    
    required init() {
        super.init()
        
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
    
    func updatePetSize(petSize : PetSizePreferences){
        if(self.dogSizePreference.value.contains(petSize)){
            self.dogSizePreference.accept(self.dogSizePreference.value.filter{$0 != petSize})
        }else{
            var updatedSet = self.dogSizePreference.value
            updatedSet.insert(petSize)
            self.dogSizePreference.accept(updatedSet)
        }
    }
    
    func updateMinderProfile(){
        let wor = allWorkingHours.value
        debugPrint(wor)
        
//        if(!basicDetailsValidationSuccess()){
//          return
//        }
//
        if(!validationSuccess()){
            return
        }
        let minderProfileRequestParam = MinderProfileRequest(
            travelling: isTravelling,
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
        
        self.userRepository.updateMinderProfile(
            minderProfileRequestParams: (minderProfileRequestParam.asParameters()))
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
                    SessionManager.shared.user = nil // clear cache user
                    self?.onUpdateMinderProfile.accept(true)
                },
                onFailure : self.error.accept
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
                    
                    if(self?.fromProfile ?? true){
                        self?.isTravelling = it.traveling ?? false
                    }
                   
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
                                to:  minderAvailability.to.asTime24Hr()
                                )
                            return dayAvailability
                        })
                    }
                    
                   
                    
                    self?.rate.accept(it.perHourRate?.asString() ?? "")
                    self?.yearsOfExpereince.accept(it.yearsOfExperience?.asString() ?? "")
                    
                    self?.dogSizePreference.accept(Set(it.petSizePreferences))
                    self?.selectedBreed.accept(it.breedPreferences?.first)
                    
                    self?.petBehaviours.accept((self?.petBehaviours.value.map{
                        $0.copy(isSelected: it.petBehaviorPreferences.contains($0.item))
                    })!)
                },
                onFailure : {_ in}//self.error.accept
            ).disposed(by: disposeBag)
    }
    
    
    func getDocuments(){
        userRepository.getAllDocuments()
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
                    self?.hasLegalDocuments.accept(!it.isEmpty)
                },
                onFailure : {_ in}
            ).disposed(by: disposeBag)
    }
    
    
    func basicDetailsValidationSuccess()->Bool{
        var messageString: String?
        if((SessionManager.shared.user?.phoneNumber?.isEmpty ?? true) && !self.hasLegalDocuments.value){
            messageString = .MinderProfileSetup.missingContactAndDocuments
        }
        
        else if(!self.hasLegalDocuments.value){
            messageString = .MinderProfileSetup.missingDocuments
        }
        
        else if(SessionManager.shared.user?.phoneNumber?.isEmpty ?? true){
            messageString = .MinderProfileSetup.missingContact
        }
        
        if let messageString = messageString{
            self.alert(messageString)
            return false
        }
        
        return true
    }
    
    func validationSuccess()->Bool{
        if(available.value == nil){
            self.alert(.MinderProfileSetup.invalidAvailability)
            return false
        }
//        else if(availableDays.value.filter{$0.isSelected}.isEmpty){
//            self.alert(.MinderProfileSetup.invalidAvailableWeekDays)
//            return false
//        }
        else if(rate.value.isEmpty){
            self.alert(.MinderProfileSetup.invalidRate)
            return false
        }
        else if(yearsOfExpereince.value.isEmpty && !noExperienceCheckbox.value){
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
        else if(!acceptTerms.value){
            self.alert(.MinderProfileSetup.termsConditionsNotAccepted)
            return false
        }
        
        return true
    }
}

struct MinderProfileRequest {
    let travelling: Bool
    let availableStatus: String
    let perHourRate: Float
    let currencyId: String
    let yearsOfExperience: Float
    let petSizePreferences: [String]
    let petBehaviorPreferences: [String]
    let breedPreferences: [[String:String]]
    let minderAvailability: [[String:Any]]
    
    func asParameters() -> Parameters{
        [
            "traveling" : travelling,
            "availableStatus" : availableStatus,
            "perHourRate" : perHourRate,
            "currencyId" : currencyId,
            "yearsOfExperience" : yearsOfExperience,
            "petSizePreferences" : petSizePreferences,
            "petBehaviorPreferences" : petBehaviorPreferences,
            "breedPreferences" : breedPreferences,
            "minderAvailability" : minderAvailability,
        ]
        
    }
    
}
