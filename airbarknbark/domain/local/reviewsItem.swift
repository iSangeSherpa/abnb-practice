//
//  reviewsItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 04/11/2022.
//

import Foundation


import UIKit
import RxDataSources

struct ReviewsItem {
    var id : String = UUID().uuidString
    var name : String
    var avatarImage : String
    var review : String
    var rating : String
    var images : [String]?
    var to : String
    
}

extension ReviewsItem{
    static func == (lhs: ReviewsItem, rhs: ReviewsItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension ReviewsItem : Equatable {}

extension ReviewsItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
