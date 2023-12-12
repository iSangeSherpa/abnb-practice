//
//  RelayType.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation
import RxRelay
import RxSwift

protocol RelayType : ObservableType where Element == RelayElement {
    
    associatedtype RelayElement
    
    func accept(_ event: RelayElement)
}

extension BehaviorRelay : RelayType { }
extension PublishRelay : RelayType { }
