//
//  GetAllPetsResponse.swift
//  airbarknbark
//
//  Created by Dipesh Paneru on 29/11/2022.
//

import Foundation
import Differentiator

struct Pet : Codable {
    let id: String
    let name: String
    let dob: String?
    let images: [String]
    let immunisationStatus: Bool?
    let behaviour : String?
    let breedId: String?
    let userId : String
    let createdAt: String?
    let updatedAt: String?
    let breed: Breed?
}



extension Pet{
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension Pet : Equatable {}

extension Pet :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
