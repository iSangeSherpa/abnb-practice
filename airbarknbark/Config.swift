//
//  Config.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation

private let PRODUCTION_URL = "https://tjzb9msrqs.ap-northeast-1.awsapprunner.com"
private let STAGING_URL = "https://b7pcmweqzd.ap-northeast-1.awsapprunner.com"

struct Config{
    #if DEBUG
        static private let BASE_URL = STAGING_URL
    #else
        static private let BASE_URL = PRODUCTION_URL
    #endif
    
    static let API_BASE_URL = "\(BASE_URL)/api"
    static let SOCKET_URL = BASE_URL
    
    static let FCM_SENDER_ID = "609298499657"
    
    static let jsonDecoder = JSONDecoder()
    static let jsonEncoder = JSONEncoder()
    
    static let allBehaviour = [ "Anxious",
                                "Calm",
                                "Shy",
                                "Friendly",
                                "Playful",
                                "Can be Reactive (people)",
                                "Can be Reactive (dogs)"]
    
    static let mapFilterMaximumDistance = 1000
    
    static let OTP_VERIFICATION_COUNTDOWN_TIMER = 1 * 60 //Seconds
    
    static let LOCATION_RANDOMIZER_RANGE : Range<Float> = -0.006..<0.006
    
    static let MAP_LOCATION_FILTER_MAX_RADIUS : Int = 500 //KM
    
    static let APP_STORE_URL = "itms-apps://itunes.apple.com/app/id1673099790"
    
}

extension DateFormatter{
   internal static var DEFAULT_DATE_FORMATTER = DateFormatter().apply { it in
        it.timeStyle = DateFormatter.Style.none
        it.dateStyle = DateFormatter.Style.short
        it.timeZone = TimeZone.current
        it.dateFormat = "yyyy-MM-dd"
    }
    
    internal static var DEFAULT_PREETY_DATE_FORMATTER = DateFormatter().apply { it in
         it.timeStyle = DateFormatter.Style.none
         it.dateStyle = DateFormatter.Style.short
         it.timeZone = TimeZone.current
         it.dateFormat = "MMM dd, yyyy"
     }
    
    internal  static var DEFAULT_TIME_FORMATTER = DateFormatter().apply { it in
        it.dateStyle = DateFormatter.Style.none
        it.timeStyle = DateFormatter.Style.short
        it.timeZone = TimeZone.current
        it.dateFormat = "hh:mm a"
    }
    internal  static var DEFAULT_TIME_FORMATTER_24HR = DateFormatter().apply { it in
        it.dateStyle = DateFormatter.Style.none
        it.timeStyle = DateFormatter.Style.short
        it.timeZone = TimeZone.current
        it.dateFormat = "hh:mm"
    }
    
    internal static var DEFAULT_DATE_TIME_FORMATTER = ISO8601DateFormatter().apply { it in
        it.formatOptions = [.withFullTime,.withFullDate, .withFractionalSeconds]
    }
    
    internal static var DEFAULT_YEAR_FORMATTER = DateFormatter().apply { it in
        it.timeZone = TimeZone.current
        it.dateFormat =  "yyyy"
    }
}
