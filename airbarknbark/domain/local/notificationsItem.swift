//
//  notificationsItem.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 18/11/2022.
//

import Foundation
import RxDataSources

struct NotificationsItem{
    var id : String = UUID().uuidString
    var text : String
    var time : String
}

extension NotificationsItem{
    static func == (lhs: NotificationsItem, rhs: NotificationsItem) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension NotificationsItem : Equatable {}

extension NotificationsItem :  IdentifiableType {
    var identity: String{
        return self.id
    }
}

