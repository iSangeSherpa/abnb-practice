//
//  Dtae.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 10/10/2022.
//

import Foundation

extension Date{
    
    func format(dateFormatter:DateFormatter) -> String {
        return dateFormatter.string(from: self)
    }
    
}
