//
//  conversationItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation

import UIKit
import RxDataSources
import RealmSwift

class Conversation : Object {
    @Persisted(primaryKey: true)  var id: String
    @Persisted  var updatedAt: String
    @Persisted  var users =  List<PublicUser>()
    
        
    convenience init(
        id: String,
        updatedAt: String,
        users: [PublicUser]
    ) {
        self.init()
        self.id = id
        self.updatedAt = updatedAt
        self.users.append(objectsIn: users)
    }
    
}

class ConversationMessage:Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var media = List<String>()
    @Persisted  var conversationID: String
    @Persisted  var fromUserID: String
    @Persisted  var createdAt: String
    @Persisted  var text: String?
    @Persisted  var type: MessageType?
    @Persisted var seenByUserIds = List<String>()
    
    convenience init(
        id: String,
        media: [String],
        conversationID: String,
        fromUserID: String,
        createdAt: String,
        text: String?,
        type: MessageType?,
        seenByUserIds : [String]
    ) {
        self.init()
        self.id = id
        self.media.append(objectsIn: media)
        self.conversationID = conversationID
        self.fromUserID = fromUserID
        self.createdAt = createdAt
        self.text = text
        self.type = type
        self.seenByUserIds.append(objectsIn: seenByUserIds)
    }
}


extension Conversation{
    var otherUser:PublicUser {
        get{
            let currentUser = SessionManager.shared.userId ?? ""
            let user = users.first
            return users.first{ it in
                it.id != currentUser
            }!
        }
    }
    
    var identity: String{
        return  self.isInvalidated ? UUID().uuidString : id
    }
}


extension ConversationMessage{
    var textRepresentation:String{
        get{
            return text ?? "\(media.count) file\(media.count > 1 ? "s" :"" )"
        }
    }
    var isSeen : Bool {
        get{
            (seenByUserIds .contains(SessionManager.shared.userId ?? ""))
        }
    }
}
