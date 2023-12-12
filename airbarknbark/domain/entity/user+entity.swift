//
//  User.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/12/2022.
//

import Foundation
import RealmSwift

enum Gender:String,Codable,CaseIterable,PersistableEnum {
    case MALE
    case FEMALE
    case OTHER
    
    func displayName()->String{
        self.rawValue.lowercased().capitalizedFirstLetter
    }
}

enum  ActiveProfile:String,Codable,PersistableEnum {
    case MINDER
    case FINDER
    case BOTH
    
    func getColor() -> UIColor{
        switch(self){
        case .MINDER:  return .blue
        case .FINDER:  return .secondary
        case .BOTH: return .primary
        
        }
    }
}

enum  ProfileCompletionStatus:String,Codable,PersistableEnum {
    case INCOMPLETE
    case COMPLETED
}

enum  ApprovalStatus:String,Codable,PersistableEnum {
    case  REVIEW_REQUIRED
    case  APPROVED
    case  REJECTED
}

enum  MinderAvailableStatus:String,Codable,PersistableEnum {
    case  AVAILABLE
    case  NOT_AVAILABLE
}

enum  AdminUserRole:String,Codable,PersistableEnum {
    case SUPER_USER
    case USER
}


enum  DeviceType:String,Codable,PersistableEnum {
    case ANDROID
    case IOS
}


enum PetSizePreferences : String,Codable,CaseIterable,PersistableEnum{
    case SMALL
    case MEDIUM
    case LARGE
}

enum AvailableStatus: String,Codable,CaseIterable,PersistableEnum {
    case AVAILABLE
    case NOT_AVAILABLE
}


enum  UserDocumentType:String, Codable, CaseIterable, CustomStringConvertible {
    case  NATIONAL_ID
    case  PASSPORT
    case  DRIVING_LICENSE
    case  OTHER
    
    var description : String{
        switch self{
        case .NATIONAL_ID:
            return "National ID"
        case .PASSPORT:
            return "Passport"
        case .DRIVING_LICENSE:
            return "Driving License"
        case .OTHER:
            return "Other"
        }
    }
}

enum NotificationType : String, Codable,PersistableEnum{
    case SENT_MINDING_REQUEST
    case RECEIVED_MINDING_REQUEST
    case MINDING_REQUEST
    case NEW_REVIEW
    case PROFILE_UPDATED
    case NEW_MESSAGE
    case NEW_CONVERSATION
    case MESSAGE_FROM_ADMIN
}
enum RequestStatus : String, Codable{
    case PENDING
    case ACCEPTED
    case REJECTED
    case CANCELLED
    case CANCELLED_BY_MINDER
    
    func getColor() -> UIColor{
        switch(self){
        case .ACCEPTED:  return .primary
        case .PENDING:  return UIColor(hexString: "#D0A114")
        case .REJECTED: return .onBackground.withAlphaComponent(0.8)
        case .CANCELLED: return .onBackground.withAlphaComponent(0.8)
        case .CANCELLED_BY_MINDER: return .onBackground.withAlphaComponent(0.8)
        }
    }
    
    func getTitle() -> String{
        switch(self){
        case .ACCEPTED:   return  "Accepted"
        case .PENDING:   return  "Pending"
        case .REJECTED:  return  "Rejected"
        case .CANCELLED: return "Cancelled"
        case .CANCELLED_BY_MINDER: return "Cancelled By Minder"
        }
    }
}

enum MessageType: String,Codable,PersistableEnum{
    case NORMAL
    case NEW_MINDING_REQUEST
}

class AddressEntity : Object {
    @Persisted  var latitude:Double
    @Persisted  var longitude:Double
    @Persisted  var name:String
    
    convenience init(
        name: String,
        longitude: Double,
        latitude: Double
    ) {
        
        self.init()
        
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}

enum UserUpdateType: String,Codable{
    case VIEW
    case UPDATE
}

enum SubscriptionType : String, Codable, CaseIterable, CustomStringConvertible {
    case MONTHLY
    case HALF_YEARLY
    case YEARLY
    
    var description : String{
        switch self{
        case .MONTHLY:
            return "airbarknbark.monthly"
        case .HALF_YEARLY:
            return "airbarknbark.halfyearly"
        case .YEARLY:
            return "airbarknbark.yearly"
        }
    }
}

enum PaymentType : String,Codable{
    case FREE
    case PAID
}
