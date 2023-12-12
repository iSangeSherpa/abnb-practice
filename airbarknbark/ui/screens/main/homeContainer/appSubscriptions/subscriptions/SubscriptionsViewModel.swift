//
//  SubscriptionsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/07/2023.
//

import Foundation
import RxRelay
import SwiftyStoreKit

class SubscriptionsViewModel : ViewModel{
    
    let onPaymentSuccess = PublishRelay<SubscriptionType>()
    let selectedSubscriptionType = BehaviorRelay<SubscriptionType?>(value: nil)
    
    let subscriptionRepository = SubscriptionRepositoryImpl()
    
    let subscriptionProfuctList = SessionManager.shared.subscriptionProductListFlow
    let activeSubscription = SessionManager.shared.activeSubscriptionFlow
    
    let expiresDate = BehaviorRelay<String> (value: "")
    
    required init() {
        super.init()
        fetchProductDetails()
        //expiresDate.accept(SessionManager.shared.user?.subscription?.expiresDate.asDateTime().asPreetyDateString() ?? "")
    }
    
    func fetchProductDetails(){
        SubscriptionHelper.shared.loadPrices{ productResult in
        }
    }
    
    func proceedPayment(){
        guard let selectedPlan = selectedSubscriptionType.value else{
            self.alert(.AppSubscription.choosePlan)
            return
        }
        
        if(SessionManager.shared.user?.subscription?.paymentType != .FREE){
            self.makePurchase(productId: selectedPlan)
        }else{
            self.alert(.AppSubscription.subscribedTofreePlan)
        }
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
                        SessionManager.shared.setActiveSubscription(productdId: productId.description)
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
}
