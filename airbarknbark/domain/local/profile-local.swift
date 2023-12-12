//
//  profile-local.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 10/10/2022.
//

import Foundation
import UIKit
import RxDataSources

let daysOfWeek = ["Sun", "Mon","Tue", "Wed", "Thu","Fri", "Sat"]

struct DayAvilability{
    var day: String
    var from: Date
    var to : Date
}

struct DocumentLocal {
    var id : String = UUID().uuidString
    var documentType : String
    var idNumber: String
    var issuePlace: String
    var images: [UIImage]
    var imagesString: [String]?
}



struct VehicleLocal{
    var id : String = UUID().uuidString
    var vehicleName: String
    var numberPlate: String
    var issuePlace: String
    var images: [UIImage]
    var imagesString: [String]?
}

extension DayAvilability :  IdentifiableType, Equatable {
    
    static func == (lhs: DayAvilability, rhs: DayAvilability) -> Bool {
        return lhs.day  == rhs.day && lhs.from  == rhs.from && lhs.to  == rhs.to
    }
    
    var identity: String{
        return self.day
    }
    
    func copy(
        day: String? = nil,
        from: Date? = nil,
        to : Date? = nil
    ) -> DayAvilability {
        return DayAvilability(
            day: day ?? self.day,
            from: from ?? self.from,
            to: to ?? self.to
        )
    }
}

extension DocumentLocal :  IdentifiableType,Equatable {
    var identity: String{
        return self.id
    }
    static func == (lhs: DocumentLocal, rhs: DocumentLocal) -> Bool {
        return lhs.id  == rhs.id
    }
}
