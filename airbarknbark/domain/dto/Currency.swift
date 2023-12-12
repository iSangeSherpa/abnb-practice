//
//  Currency.swift
//  airbarknbark
//
//  Created by Dipesh Paneru on 30/11/2022.
//

import Foundation
struct Currency: Codable {
    var id : String
    var name : String
    var symbol : String
    var shortName : String?
    var createdAt : String?
    var  updatedAt: String?
}
