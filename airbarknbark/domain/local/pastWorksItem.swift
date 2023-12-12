//
//  PastWorksItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 12/12/2022.
//

import Foundation
import Differentiator


struct PastWorksItem{
    var id : String = UUID().uuidString
    var name : String
    var imageURL : String
    var date : String
    var time : String
    var totalReceived : String
    var isProfileVerified : Bool
}

extension PastWorksItem{
    static func == (lhs: PastWorksItem, rhs: PastWorksItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension PastWorksItem : Equatable {}

extension PastWorksItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
