//
//  YourPetsItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 16/11/2022.
//

import Foundation
import RxDataSources


struct YourPetsItem {
    var id : String = UUID().uuidString
    var name : String
    var age : String
    var breed : String
    var immunizationStatus : Bool
    var imageURL : String
    
}


extension YourPetsItem{
    static func == (lhs: YourPetsItem, rhs: YourPetsItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension YourPetsItem : Equatable {}

extension YourPetsItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
