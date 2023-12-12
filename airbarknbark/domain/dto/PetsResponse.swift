//
//  AllPetsResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/11/2022.
//

import Foundation
import Differentiator


struct PetDetails : Codable{
    var id : String
    var name : String
    var dob : String
    var about : String?
    var images : [String]
    var immunizationStatus : Bool
    var behavior : String
    var breedId : String
    var userId : String?
    var createdAt : String?
    var updatedAt : String?
    var breed : Breed?
    
}
extension PetDetails{
    static func == (lhs: PetDetails, rhs: PetDetails) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension PetDetails : Equatable {}

extension PetDetails :  IdentifiableType {
    var identity: String{
        return self.id
    }
}

