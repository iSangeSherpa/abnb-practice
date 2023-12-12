//
//  SubscriptionPriceLoader.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/07/2023.
//

import Foundation
import SwiftyStoreKit
import TPInAppReceipt



struct SubscriptionModel : Codable{
    let id: String
    let type: SubscriptionType
    let priceString: String
    let price: Double
}



class SubscriptionHelper {
   static let shared = SubscriptionHelper()
    
   typealias SubscriptionCompletion = Result<[SubscriptionModel],Error>

   func loadPrices(completion: @escaping (SubscriptionCompletion) -> Void){
       SwiftyStoreKit.retrieveProductsInfo(Set(SubscriptionType.allCases.map{$0.description})) { results in
           guard results.error == nil else {
               print("loadPricesError", results.error!)
               completion(SubscriptionCompletion.failure(results.error!))
               return
               
           }
           let products = results.retrievedProducts
           var subscriptions : [SubscriptionModel] = []
           
           if let monthlySubscription = products.filter({$0.productIdentifier == SubscriptionType.MONTHLY.description}).first, let price = monthlySubscription.localizedPrice {
               subscriptions.append(SubscriptionModel(id: monthlySubscription.productIdentifier, type: SubscriptionType.MONTHLY, priceString: "\(price) / Month", price: Double(truncating: monthlySubscription.price)))
           }
           if let halfYearlySubscription = products.filter({$0.productIdentifier == SubscriptionType.HALF_YEARLY.description}).first, let price = halfYearlySubscription.localizedPrice {
               subscriptions.append(SubscriptionModel(id: halfYearlySubscription.productIdentifier, type: SubscriptionType.HALF_YEARLY, priceString: "\(price) / 6 Months", price: Double(truncating: halfYearlySubscription.price)))
           }
           
           if let yearlySubscription = products.filter({$0.productIdentifier == SubscriptionType.YEARLY.description}).first, let price = yearlySubscription.localizedPrice {
               subscriptions.append(SubscriptionModel(id: yearlySubscription.productIdentifier, type: SubscriptionType.YEARLY, priceString: "\(price) / Year", price: Double(truncating: yearlySubscription.price)))
           }
           
           SessionManager.shared.subscriptionProductList = subscriptions
           completion(.success(subscriptions))
       }
   }
    
    
    func getReceipt(completion: @escaping (InAppReceipt?) -> Void) {
        if let receiptData = SwiftyStoreKit.localReceiptData {
            do {
                let receipt = try InAppReceipt.receipt(from: receiptData)
                completion(receipt)
            }catch {
                completion(nil)
            }
        }else {
            //no receipt, hence force a refresh
            SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
                switch result {
                case .success(let receiptData):
                    do {
                        let receipt = try InAppReceipt.receipt(from: receiptData)
                        completion(receipt)
                    }
                    catch {
                        completion(nil)
                    }
                case .error(let _):
                    completion(nil)
                }
            }
        }
    }
    
    
}
