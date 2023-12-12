//
//  mindingItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/11/2022.
//

import Foundation

import UIKit
import RxDataSources

struct MindingItem {
    var id : String = UUID().uuidString
    var name : String
    var imageURL : String
    var leftTime : String
    var location : String
    var startedTime : String
    var isProfileVerified : Bool
    
}

extension MindingItem{
    static func == (lhs: MindingItem, rhs: MindingItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension MindingItem : Equatable {}

extension MindingItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
