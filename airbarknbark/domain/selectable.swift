//
//  selectable.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 11/10/2022.
//

import Foundation
import RxDataSources


struct Selectable<T>{
    var item:T
    var isSelected:Bool
    
    func copy(isSelected:Bool) -> Selectable<T>{
        return Selectable(item: item, isSelected: isSelected)
    }
}


extension Selectable : Equatable where T : Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool{
        return  lhs.isSelected && rhs.isSelected && lhs.item == rhs.item 
    }
}

extension Selectable :  IdentifiableType where T : IdentifiableType, T.Identity == String {
    var identity: String{
        item.identity
    }
}

