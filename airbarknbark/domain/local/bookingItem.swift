//
//  bookingItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation


import UIKit
import RxDataSources

struct BookingItem {
    var id : String = UUID().uuidString
    var name : String
    var imageURL : String
    var date : String
    var timeDuration : String
    var rate : String
    var perTime : String
    var isProfileVerified : Bool
    
}

extension BookingItem{
    static func == (lhs: BookingItem, rhs: BookingItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension BookingItem : Equatable {}

extension BookingItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
