//
//  RegisterResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 22/11/2022.
//

import Foundation

struct RegisterDetails: Codable {
    let id : String
    let email : String
    let active  : Bool
    let emailVerified : Bool
    let phoneVerified : Bool
    let completionStatus : String
    let createdAt : String
    let updatedAt : String
    
}
 
