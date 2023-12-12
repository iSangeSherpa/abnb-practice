//
//  AppSubscrptionResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 27/07/2023.
//

import Foundation


struct CheckActiveSubscriptionResponse : Codable{
    let hasActiveSubscription : Bool
}

struct InitialSubscriptionResponse : Codable{
    let email : String
}
