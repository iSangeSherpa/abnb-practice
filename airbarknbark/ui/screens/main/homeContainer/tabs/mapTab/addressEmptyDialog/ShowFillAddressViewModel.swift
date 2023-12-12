//
//  ShowFillAddressViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/08/2023.
//

import Foundation
import RxSwift
import RxRelay

class ShowFillAddressViewModel : ViewModel{
    
    let userRepository = UserRepositoryImpl()
    let address = BehaviorRelay<AddressDetails?>(value: nil)
    
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
    
}
