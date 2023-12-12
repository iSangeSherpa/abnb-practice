//
//  Review.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/12/2022.
//

import Foundation

struct Reviews : Codable{
    let id : String
    let message : String
    let images : [String]
    let rating : Int
    let mindingRequestId : String
    let fromUserId : String
    let toUserId : String?
    let toPetId : String?
    let toPet : Pet?
    let toUser : Profile?
    let fromUser : Profile?
    let createdAt : String
    let updatedAt : String
}
