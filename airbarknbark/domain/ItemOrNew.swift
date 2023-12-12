//
//  common.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation
import Differentiator


enum ItemOrNew <T> {
    case Item(T)
    case New
}


extension ItemOrNew : Equatable where T : Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool{
        
    switch lhs{
        case .New :
            if case rhs = ItemOrNew.New{
                return true
            }
            return false
            
        case .Item(let lhsValue):
            if case ItemOrNew.Item(let rhsValue) = rhs {
                return lhsValue == rhsValue
            }
            return false
        }
    }
}

extension ItemOrNew :  IdentifiableType where T : IdentifiableType, T.Identity == String {
    var identity: String{
        
        switch self {
        case .New :
            return "new-item"
        case .Item(let value) :
            return value.identity
        }
        
    }
}

