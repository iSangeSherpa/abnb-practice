//
//  conversations+dto.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 12/12/2022.
//

import Foundation

struct ConversationMessageModel:Codable {
    var id: String
    var media : [String]
    var text : String?
    var conversationId: String
    var fromUserId: String
    var createdAt: String
    var type: MessageType?
    var isSeenUserId : [String]?
    
    func toDomain()->ConversationMessage{
        return ConversationMessage(
            id: id,
            media: media,
            conversationID: conversationId,
            fromUserID: fromUserId,
            createdAt: createdAt,
            text:text,
            type:type,
            seenByUserIds: isSeenUserId ?? []
        )
    }
}


struct ConversationModel:Codable {
    var id: String
    var updatedAt: String
    var messages: [ConversationMessageModel]
    var users : [PublicUserModel]
    
    func toDomain() -> Conversation{
        return Conversation(
            id: id,
            updatedAt: updatedAt,
            users: users.map{ it in
                it.toDomain()
            }
        )
    }
}

