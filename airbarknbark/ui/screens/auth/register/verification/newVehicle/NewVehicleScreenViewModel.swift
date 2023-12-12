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
import Alamofire
import Differentiator

struct ImageOrURL : Equatable, IdentifiableType{
    let id : String = UUID().uuidString
    let image : UIImage?
    let imageURL : String?
    
    
    static func == (lhs: ImageOrURL, rhs: ImageOrURL) -> Bool {
        return lhs.id  == rhs.id
    }
     
    var identity: String{
        return self.id
    }
    
}
class NewVehicleScreenViewModel : ViewModel{
    
    let utilRepository = UtilRepositoryImpl()
    let userRepository = UserRepositoryImpl()
    
    let vehicleName = BehaviorRelay(value: "")
    let numberPlate = BehaviorRelay(value: "")
    let issuedPlace = BehaviorRelay(value: "")
    
    let images =  BehaviorRelay<[ImageOrURL]>(value: [])
    
    let doneButtonClick = PublishRelay<Void>()
    let removeImageButtonClick = PublishRelay<ImageOrURL>()
    let newImageButtonClicked = PublishRelay<Void>()
    
    let onNewVehicle = PublishRelay<VehicleDetails>()
    
    required init() {
        super.init()
        
        doneButtonClick
            .bind { [self] it in
                addVehicle(vehicle:VehicleLocal(
                    vehicleName: vehicleName.value,
                    numberPlate: numberPlate.value,
                    issuePlace: issuedPlace.value,
                    images: []
                ))
            }.disposed(by: disposeBag)
        
        removeImageButtonClick.withLatestFrom(images){ (toRemove, all)  in
            all.filter {
                !($0 == toRemove)
            }
        }
        .bind(to: images)
        .disposed(by: disposeBag)
        
        onNewVehicle.map { DocumentLocal in
            
        }.bind(to: dismissBy)
            .disposed(by: disposeBag)
    }
    
    func loadVehicleInfo(vehicle: VehicleDetails){
        vehicleName.accept(vehicle.name)
        numberPlate.accept(vehicle.numberPlate)
        images.accept(vehicle.images.map{ImageOrURL(image: nil, imageURL: $0)})
        issuedPlace.accept(vehicle.issuePlace)
    }
    
    func addVehicle(vehicle:VehicleLocal){
        if(!validationSuccess()){
            return
        }
        
        let imagesObservables  =  images.value.filter{$0.image != nil}
            .map { image in
                utilRepository.uploadFile(fileData: (image.image!.jpeg(.high))!, fileName: "img.jpeg", type: .OTHER)
            }
        
        Single.zip(imagesObservables) { it  in
            it.map { $0.path }
        }
        .flatMap{ (images:[String])-> Single<VehicleDetails> in
            var vehicleDetail = vehicle
            vehicleDetail.imagesString = images + self.images.value.filter{$0.imageURL != nil}.map{$0.imageURL!}
            return self.userRepository.updateVehicleDetail(vehicle: vehicleDetail)
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
                onSuccess: {  [weak self] vehicleDetails in
                    self?.onNewVehicle.accept(vehicleDetails)
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
            }
    
    func validationSuccess()->Bool{
        if(vehicleName.value.isEmpty){
            self.alert(.NewVehicle.invalidVehicleName)
            return false
        }
        else if(numberPlate.value.isEmpty){
            self.alert(.NewVehicle.invalidNumberPlate)
            return false
        }
        else if(issuedPlace.value.isEmpty){
            self.alert(.NewVehicle.invalidIssuedPlace)
            return false
        }
        else if(images.value.count == 0){
            self.alert(.NewVehicle.invalidVehiclePhoto)
            return false
        }
        return true
    }
}
