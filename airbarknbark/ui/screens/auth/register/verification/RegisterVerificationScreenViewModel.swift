//
//  RegisterVerificationScreenViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 27/09/2022.
//

import Foundation
import RxRelay
import RxSwift

class RegisterVerificationScreenViewModel : ViewModel{
    var forIncompleteProfile = false
    
    let userRepository = UserRepositoryImpl()
    
    let dateOfBirth = BehaviorRelay<Date?>(value: nil)
    let address = BehaviorRelay<Address?>(value: nil)
    let vehicle = BehaviorRelay<VehicleDetails?>(value: nil)
    let contactNumber = BehaviorRelay<String>(value: "")
    let emergencyContactNumber = BehaviorRelay<String>(value: "")
    let showMyNumber = BehaviorRelay<Bool>(value: true)
    let hasPasCriminalActivity = BehaviorRelay<Bool>(value: true)
    
    let documents = BehaviorRelay<[DocumentDetails]>(value: [])
    
    let documentClicked = PublishRelay<DocumentDetails>()
    let newDocumentClicked = PublishRelay<Void>()
    let removeDocumentClicked = PublishRelay<String>()
    let onUpdateUserVerificationForm = PublishRelay<Bool>()
    
    required init() {
        super.init()
        removeDocumentClicked.bind{
            [self] docId in
            self.removeDocument(documentId: docId)
        }
        .disposed(by: disposeBag)
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
                    self?.address.accept(Address(lat: Double(it.latitude), lang: Double(it.longitude), name: it.name))
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
                self?.address.accept(Address(lat: 0.00 , lang: 0.00, name: ""))
            },
            onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func removeDocument(documentId: String){
        self.userRepository.removeDocument(documentId: documentId)
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
                onSuccess: { [self] idResponse in
                    self.documents.accept(documents.value.filter { docItem in
                        idResponse.id != docItem.id
                    })
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
        
    }
    
    
    func updateVerificationDetail(){
        if(!validationSuccess()){
            return
        }
        
        self.userRepository.updateUserDetails(
            dob: dateOfBirth.value?.asDateString(),
            phoneNumber: contactNumber.value.isEmpty ? nil : contactNumber.value,
            showMyNumber : showMyNumber.value,
            emergencyContact: emergencyContactNumber.value.isEmpty ? nil : emergencyContactNumber.value
        )
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            })
        .subscribe(onSuccess: {
            updateUserDetailResponse in
            SessionManager.shared.user  = nil // clear cache user
            self.onUpdateUserVerificationForm.accept(true)
            
        },onFailure:self.error.accept).disposed(by: disposeBag)
        
    }
    
    func validationSuccess()->Bool{
        if false {
            if(dateOfBirth.value == nil){
                self.alerts.accept(.error(.RegisterVerification.invalidDob))
                return false
            }
            if(documents.value.isEmpty){
                self.alerts.accept(.error(.RegisterVerification.invalidDocument))
                return false
            }
            if(contactNumber.value.count<10){
                self.alerts.accept(.error(.RegisterVerification.invalidContactNumber))
                return false
            }
            if(emergencyContactNumber.value.count<10){
                self.alerts.accept(.error(.RegisterVerification.invalidEmergencyContactNumber))
                return false
            }
        }
//        else if(address.value == nil){
//            self.alerts.accept(.error(.RegisterVerification.invalidAddress))
//            return false
//        }
       
        else if(hasPasCriminalActivity.value){
            self.alerts.accept(.error(.RegisterVerification.hasCriminalActivity))
            return false
        }
        return true
    }
    
    func loadData(){
        self.loadUserDetails()
        self.loadAddress()
        self.loadDocuments()
        self.loadVehicleDetails()
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
                    self?.dateOfBirth.accept(it.dob?.asDate())
                    self?.contactNumber.accept(it.phoneNumber ?? "")
                    self?.showMyNumber.accept(!(it.hidePhoneNumber ?? false))
                    self?.emergencyContactNumber.accept(it.emergencyPhoneNumber ?? "")
                },
                onFailure : { it in
                    
                }
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
                    self?.address.accept(Address(lat: Double(it.latitude), lang: Double(it.longitude), name: it.name))
                },
                onFailure : { it in
                    
                }
            ).disposed(by: disposeBag)
    }
    
    func loadDocuments(){
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
                    self?.documents.accept(it)
                },
                onFailure : { it in
                    
                }
            ).disposed(by: disposeBag)
    }
    
    func loadVehicleDetails(){
        userRepository.getVehicleDetails()
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
                    self?.vehicle.accept(it.first)
                },
                onFailure : { it in
                    
                }
            ).disposed(by: disposeBag)
    }
}
