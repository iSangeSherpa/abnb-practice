//
//  realm+extensions.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 12/12/2022.
//

import Foundation
import RealmSwift

extension Array where Element: RealmCollectionValue {
    func asRealmList()->List<Element>{
        var list = List<Element>()
        list.append(objectsIn: self)
        
        return list
    }
}
