//
//  pet.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation
import UIKit
import RxDataSources

struct PetLocal{
    var id : String = UUID().uuidString
    var name : String
    var dateOfBirth: String
    var about : String
    var breed : Breed?
    var immunizationStatus: Bool
    var behaviour:  String
    var images: [UIImage]
    var imagesString : [String]?
}

extension PetLocal{
    static func == (lhs: PetLocal, rhs: PetLocal) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension PetLocal : Equatable {}

extension PetLocal :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
