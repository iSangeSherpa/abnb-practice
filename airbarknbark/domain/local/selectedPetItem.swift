//
//  petItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 04/11/2022.
//

import Foundation

import UIKit
import RxDataSources

struct SelectedPetItem {
    var id : String = UUID().uuidString
    var name : String
    var age : String
    var breed : String
    var about : String?
    var immunizationStatus: Bool
    var imageURL : String
    
}

extension SelectedPetItem{
    static func == (lhs: SelectedPetItem, rhs: SelectedPetItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension SelectedPetItem : Equatable {}

extension SelectedPetItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
