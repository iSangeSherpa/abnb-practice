//
//  NotificationResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 14/12/2022.
//

import Foundation
struct NotificationModel : Codable{
    
    let id : String
    let isSeen : Bool
    let type : NotificationType
    let description : String
    let image : String
    let resourceId : String
    let userId : String
    let createdAt : String
    let updatedAt : String
    
    func toDomain() -> Notification{
        return Notification(
            id : id,
            isSeen : isSeen,
            type : type,
            text : description,
            image : image,
            resourceId : resourceId,
            userId : userId,
            createdAt : createdAt,
            updatedAt : updatedAt
        )
    }
}
