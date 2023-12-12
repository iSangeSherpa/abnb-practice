//
//  SubscriptionPaymentDialogViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/07/2023.
//

import Foundation
import RxRelay
import TPInAppReceipt
import SwiftyStoreKit
import FirebaseMessaging
import RxSwift


class SubscriptionPaymentDialogViewModel : ViewModel{
    let onPaymentSuccess = PublishRelay<SubscriptionType>()
    let selectedSubscriptionType = BehaviorRelay<SubscriptionType?>(value: nil)
    let prouctDetails = BehaviorRelay<[SubscriptionModel]?>(value: nil)
    
    let userRepository = UserRepositoryImpl()
    let subscriptionRepository = SubscriptionRepositoryImpl()
    
    let onLogoutSuccess = PublishRelay<Void>()
    
    required init() {
        super.init()
        fetchProductDetails()
    }
    
    func fetchProductDetails(){
        SubscriptionHelper.shared.loadPrices{ productResult in
            switch(productResult){
            case .success(let productDetails):
                self.prouctDetails.accept(productDetails)
                break
                
            case .failure(let error):
                self.prouctDetails.accept(nil)
                break
                
            }
        }
    }
    
    func proceedPayment(){
        guard let selectedPlan = selectedSubscriptionType.value else{
            self.alert(.AppSubscription.choosePlan)
            return
        }
        
        self.makePurchase(productId: selectedPlan)
    }
    
   
    func makePurchase(productId: SubscriptionType) {
        self.loading.accept(true)
        SwiftyStoreKit.purchaseProduct(productId.description) { result in
            self.loading.accept(false)
            switch result {
            case .success(let purchase):
                print("Purchase successful: \(purchase.productId)")
                //getReceipt and send it to server
                self.getReceiptAndSendToServer(productId: productId)
               
            case .error(let error):
                print("Purchase failed: \(error.localizedDescription)")
                
                switch error.code {
                case .paymentCancelled:
                    break
                default:
                    self.alert(error.localizedDescription)
                }
            }
        }
    }
    
    
  
    
    
    func getReceiptAndSendToServer(productId : SubscriptionType){
        SubscriptionHelper.shared.getReceipt(){ inAppRecept in
            guard let receipt = inAppRecept else{
                self.alert("Receipt not found")
                return
            }
            print(receipt.base64)
            //Send receipt to server
            
            self.subscriptionRepository.sendReceiptToServer(receipt: receipt.base64 )
                .do(
                    onSubscribe: { [weak self] in
                        self?.loading.accept(true)
                    },
                    onDispose: { [weak self] in
                        self?.loading.accept(false)
                    }
                )
                .subscribe(
                    onSuccess: { subscriptionDetails in
                        self.onPaymentSuccess.accept(productId)
                    },
                    onFailure: self.error.accept(_:)
                ).disposed(by: self.disposeBag)
              
        }
    }
 
    
    func restorePurchase(){
        self.loading.accept(true)
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            self?.loading.accept(false)
            guard let self = self else {return}
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.alert("Restore Failed: \(results.restoreFailedPurchases)",alertFor: .error)
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.alert("Successfully Restored: \(results.restoreFailedPurchases)",alertFor: .success)
            }
            else{
                self.alert("Nothing to restore!",alertFor: .success)
            }
        }
    }
    
    func deleteAccount(){
        userRepository.deleteAccount()
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
                    Messaging.messaging().deleteFCMToken(forSenderID: Config.FCM_SENDER_ID, completion: { _ in})
                    SessionManager.shared.clearSession()
                    self?.onLogoutSuccess.accept(Void())
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func logout(){
        userRepository.logout()
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
                    Messaging.messaging().deleteFCMToken(forSenderID: Config.FCM_SENDER_ID, completion: { _ in})
                    SessionManager.shared.clearSession()
                    self?.onLogoutSuccess.accept(Void())
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
}
