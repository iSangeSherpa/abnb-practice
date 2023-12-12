//
//  RequestsItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation

import UIKit
import RxDataSources

struct MindingRequestItem {
    var id : String = UUID().uuidString
    var name : String
    var imageURL : String
    var date : String
    var requestStatus : RequestStatus
    var isProfileVerified : Bool
    
}

extension MindingRequestItem{
    static func == (lhs: MindingRequestItem, rhs: MindingRequestItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension MindingRequestItem : Equatable {}

extension MindingRequestItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
