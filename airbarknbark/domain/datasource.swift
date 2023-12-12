//
//  datasource.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation
import RxDataSources


struct SectionOf<Item>: Identifiable where Item : Equatable, Item : IdentifiableType  {
    typealias Identity = String
    
    var items: [Item]
    
    var id: Identity  = UUID().uuidString
}

extension SectionOf: AnimatableSectionModelType {
    typealias Item = Item
    
    init(original: SectionOf, items: [Item]) {
        self = original
        self.items = items
    }
    
    var identity: Identity {
        return self.id
    }
}
