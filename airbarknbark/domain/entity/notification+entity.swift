//
//  notification+entity.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 14/12/2022.
//

import Foundation
import RealmSwift


class Notification : Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var isSeen : Bool
    @Persisted var type : NotificationType
    @Persisted var text : String
    @Persisted var image : String
    @Persisted var resourceId : String
    @Persisted var userId : String
    @Persisted var createdAt : String
    @Persisted var updatedAt : String
    
    convenience  init(
        id : String,
        isSeen : Bool,
        type : NotificationType,
        text : String,
        image : String,
        resourceId : String,
        userId : String,
        createdAt : String,
        updatedAt : String){
            self.init()
            self.id = id
            self.isSeen = isSeen
            self.type = type
            self.text = text
            self.image = image
            self.resourceId = resourceId
            self.userId = userId
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
}
