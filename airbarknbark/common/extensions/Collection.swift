//
//  Collection.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Sequence {
    subscript(index: Int) -> Self.Iterator.Element? {
        return enumerated().first(where: {$0.offset == index})?.element
    }
}

