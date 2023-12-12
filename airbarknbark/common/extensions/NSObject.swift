//
//  Any.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/09/2022.
//

import Foundation
import UIKit
import RxDataSources

protocol HasApply { }

extension HasApply {
    @discardableResult
    func apply(_ closure: (_ it :  Self) -> ()) -> Self {
        closure(self)
        return self
    }
}


extension NSObject: HasApply { }
extension AnimationConfiguration : HasApply { }
extension URLRequest : HasApply {}
extension JSONEncoder:HasApply {}
extension JSONDecoder : HasApply{}
