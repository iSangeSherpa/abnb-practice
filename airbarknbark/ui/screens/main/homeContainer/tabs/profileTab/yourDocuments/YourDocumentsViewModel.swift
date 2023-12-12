//
//  YourDocumentsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 16/11/2022.
//

import Foundation
import RxRelay
import RxSwift

class YourDocumentsViewModel : ViewModel{
    let userRepository = UserRepositoryImpl()
    let utilRepository = UtilRepositoryImpl()
    
    let allDocuments =  BehaviorRelay<[DocumentDetails]>(value: [])
    
    let documentClicked =  PublishRelay<DocumentDetails>()
    let onNewDocumentClicked = PublishRelay<DocumentDetails>()
    
    required init() {
        super.init()
        
        self.getDocuments()
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
                    self?.allDocuments.accept(it)
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
                    self.allDocuments.accept(allDocuments.value.filter { docItem in
                        idResponse.id != docItem.id
                    })
                },
                onFailure: self.error.accept
            ).disposed(by: disposeBag)
    }
    
}
