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


class NewDocumentViewModel : ViewModel{
    var document : DocumentDetails? = nil
    
    let utilRepository = UtilRepositoryImpl()
    let userRepository = UserRepositoryImpl()
   
    let documentType = BehaviorRelay<UserDocumentType?>(value:nil)
    let idNumber = BehaviorRelay(value: "")
    let issuedPlace = BehaviorRelay(value: "")

    let images =  BehaviorRelay<[ImageOrURL]>(value: [])

    let doneButtonClick = PublishRelay<Void>()
    let removeImageButtonClick = PublishRelay<ImageOrURL>()
    let newImageButtonClicked = PublishRelay<Void>()

    let onNewDocument = PublishRelay<DocumentDetails>()
    let allDocumentTypes = BehaviorRelay<[UserDocumentType]>(value: UserDocumentType.allCases)

    required init() {
        super.init()
      
        doneButtonClick
            .bind { [self] it in
                self.createOrUpdate(document: DocumentLocal(
                    id: document?.id ?? "",
                    documentType: documentType.value?.rawValue ?? UserDocumentType.OTHER.rawValue,
                    idNumber: idNumber.value,
                    issuePlace: issuedPlace.value,
                    images: []
                ), update: document != nil)
            }
            .disposed(by: disposeBag)

        removeImageButtonClick.withLatestFrom(images){ (toRemove, all)  in
            all.filter {
                $0 != toRemove
            }
        }
        .bind(to: images)
        .disposed(by: disposeBag)
        
        onNewDocument.map { DocumentLocal in
            
        }.bind(to: dismissBy)
            .disposed(by: disposeBag)
    }
    
    func loadDocumentDetails(){
        if(document != nil){
            documentType.accept(document?.type)
            idNumber.accept(document?.documentId ?? "")
            issuedPlace.accept(document?.issuePlace ?? "")
            
            self.images.accept(document?.files.map{
                $0.map{ImageOrURL(image: nil, imageURL: $0)}
            } ?? [])
        }
    }
    
    
    func createOrUpdate(document: DocumentLocal , update : Bool = false){
        if(!validationSuccess()){
            return
        }
        let imagesObservables  =   images.value.filter{$0.image != nil}
            .map { image in
                utilRepository.uploadFile(fileData: image.image!.jpeg(.high)!, fileName: "img.jpeg", type: .OTHER)
            }
        
        Single.zip(imagesObservables) { it  in
            it.map { $0.path }
        }
        .flatMap{ (images:[String])-> Single<DocumentDetails> in
            var documentDetail = document
            documentDetail.imagesString = images + self.images.value.filter{$0.imageURL != nil}.map{$0.imageURL!}
            
            if(update){
                return self.userRepository.updateDocumentDetail(document: documentDetail)
            }else{
                return self.userRepository.createDocument(document: documentDetail)
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
            onSuccess: {  [weak self] documentDetails in
                self?.onNewDocument.accept(documentDetails)
            },
            onFailure: self.error.accept
        ).disposed(by: disposeBag)
    }
    
   
    func validationSuccess()->Bool{
        if(documentType.value == nil){
            self.alerts.accept(.error(.NewDocument.invalidDocumentType))
            return false
        }
        else if(idNumber.value.isEmpty){
            self.alerts.accept(.error(.NewDocument.invalidIdentificationNumber))
            return false
        }
        else if(issuedPlace.value.isEmpty){
            self.alerts.accept(.error(.NewDocument.invalidIssuedPlace))
            return false
        }
        else if(images.value.isEmpty){
            self.alerts.accept(.error(.NewDocument.invalidDocumentPhoto))
            return false
        }
        return true
    }
}
