//
//  BreedSelectionViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 19/12/2022.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

class BreedSelectionBottomSheetViewModel:ViewModel {
    
    private let petRepository = PetsRepositoryImpl()
    
    let onBreedSelected = PublishRelay<Breed>()
    let searchValue = BehaviorRelay(value: "")
    
    lazy var searchResult = Observable.combineLatest(searchValue,petRepository.getAllBreedsFlow()){ label, all in
        label.isEmpty ? all : all.filter( { it in
            it.name.lowercased().contains(label.lowercased())
        })
    }

    required init() {
        super.init()
        
        refreshBreeds()
    }
    
    func refreshBreeds(){
        
        petRepository.refreshBreeds()
            .subscribe(
                onError: error.accept(_:)
            ).disposed(by: disposeBag);
        
    }
    
    func addBreed(name:String){
        petRepository.addBreed(name: name)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(
                onSuccess: onBreedSelected.accept(_:),
                onFailure: error.accept(_:)
            ).disposed(by: disposeBag)
    }
    
}
