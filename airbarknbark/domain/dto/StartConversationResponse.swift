//
//  StartConversationResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 05/12/2022.
//

import Foundation

struct ConversationDetails : Codable{
    
    let id : String
    let createdAt : String
    let updatedAt : String
    let users : [Profile]
    let messages: [Message]
}

struct Message : Codable{
    let id : String
    let text : String?
    let media : [String]
    let conversationId : String
    let fromUserId : String
    let createdAt : String
}
