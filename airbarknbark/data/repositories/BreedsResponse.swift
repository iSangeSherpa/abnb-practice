//
//  BreedsResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 23/11/2022.
//

import Foundation

struct BreedModel : Codable {
    let id : String
    let name : String
    let createdAt : String
    let updatedAt : String
}

extension BreedModel{
    func toDomain() -> Breed{
        return .init(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
