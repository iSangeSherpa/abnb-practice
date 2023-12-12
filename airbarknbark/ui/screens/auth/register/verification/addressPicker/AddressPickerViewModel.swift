//
//  AddressPickerViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 23/11/2022.
//

import Foundation
import RxRelay

class AddressPickerViewModel : ViewModel{
    let onAddressSelected = PublishRelay<Address>()
    let address = BehaviorRelay<Address?>(value: nil)
    
    let locationSearchResult = BehaviorRelay<[Address]>(value: [])
    
    required init() {
        super.init()
        
        onAddressSelected.map { _ in
            }.bind(to: dismissBy)
            .disposed(by: disposeBag)
    }
}
