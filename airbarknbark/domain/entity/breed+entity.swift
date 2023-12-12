//
//  breed+entity.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 20/12/2022.
//

import Foundation
import RealmSwift

class Breed : Object, Codable {
    @Persisted(primaryKey: true)
    var id : String
    @Persisted var name : String
    @Persisted var createdAt : String
    @Persisted var updatedAt : String
    
    convenience init(
        id: String,
        name: String,
        createdAt: String,
        updatedAt: String
    ) {
        self.init()
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
