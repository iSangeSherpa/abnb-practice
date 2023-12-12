//
//  SubscriptionRepository.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 27/07/2023.
//

import Foundation
import RxSwift

protocol  SubscriptionRepository{
    func sendReceiptToServer(receipt : String) -> Single<String>
    func checkActiveSubscription() -> Single<CheckActiveSubscriptionResponse>
    
}

class SubscriptionRepositoryImpl : SubscriptionRepository{
    func checkActiveSubscription() -> Single<CheckActiveSubscriptionResponse> {
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.checkActiveSubscription(userId : userId).map{$0.data}
    }
    
    func sendReceiptToServer(receipt: String) -> Single<String> {
        let userId = SessionManager.shared.userId ?? ""
        let params = ["receiptId" : receipt]
        return ApiService.sendReceiptToServer(userId : userId, params: params).map{$0.data}
    }
    
    func checkForInitialSubscription(receipt : String) -> Single<String>{
        let userId = SessionManager.shared.userId ?? ""
        let params = ["receiptId" : receipt]
        return ApiService.checkForInitialSubscription(userId : userId, params: params).map{$0.data.email}
    }
}
