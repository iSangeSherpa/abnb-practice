//
//  BlockedUsersResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/02/2023.
//

import Foundation

struct BlockedUser : Codable{
    
    let blockedUser: BlockedUserDetails
}

struct BlockedUserDetails:Codable{
    let id : String
    let fullName : String
    let image : String
    let address : AddressModel?
}
