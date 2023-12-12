//
//  String+DateTimes.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/12/2022.
//

import Foundation

extension String{
    
    func asTime()->Date{
       return DateFormatter.DEFAULT_TIME_FORMATTER.date(from: self)!
    }
    
    func asTime24Hr()->Date{
       return DateFormatter.DEFAULT_TIME_FORMATTER_24HR.date(from: self)!
    }
    
    func asDate()->Date{
       return DateFormatter.DEFAULT_DATE_FORMATTER.date(from: self)!
    }
    
    func asDateTime()->Date{
        return DateFormatter.DEFAULT_DATE_TIME_FORMATTER.date(from: self)!
    }
    
    func asYearDate() -> Date{
        return DateFormatter.DEFAULT_YEAR_FORMATTER.date(from: self)!
    }
}

extension Date{
    func asTimeString()->String{
        return DateFormatter.DEFAULT_TIME_FORMATTER.string(from: self)
    }
    
    func as24HourTimeString()->String{
        return DateFormatter.DEFAULT_TIME_FORMATTER_24HR.string(from: self)
    }
    
    func asPreetyDateString()->String{
        return DateFormatter.DEFAULT_PREETY_DATE_FORMATTER.string(from: self)
    }
    
    func asDateString()->String{
       return DateFormatter.DEFAULT_DATE_FORMATTER.string(from: self)
    }
    
    func asDisplayDateTimeString()->String{
        return [asDateString(),asTimeString()].joined(separator: " ")
    }
    
    func asDateTimeString()->String{
       return DateFormatter.DEFAULT_DATE_TIME_FORMATTER.string(from: self)
    }
    
    func asYearString() -> String {
        return DateFormatter.DEFAULT_YEAR_FORMATTER.string(from: self)
    }
    
    func ageYears()->Int{
       return Calendar.current.dateComponents([.year], from: self, to: .now).year!
    }

}
