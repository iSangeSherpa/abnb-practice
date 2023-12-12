//
//  MapListItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation

import UIKit
import RxDataSources

struct MapListItem {
    var id : String = UUID().uuidString
    var name : String
    var rating : String
    var experience : String
    var availableDays : [String]
    var perHourRate : String
    var distance : (String,Double)
    var imageURL : String
    var phone : String
    var showMyNumber : Bool?
    var address : AddressDetails?
    var activeProfile : ActiveProfile
    var isProfileVerified :Bool
    var hasMinderProfile : Bool
   
}

extension MapListItem{
    static func == (lhs: MapListItem, rhs: MapListItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension MapListItem : Equatable {}

extension MapListItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
