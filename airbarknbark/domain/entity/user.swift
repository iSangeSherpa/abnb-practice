//
//  User.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/12/2022.
//

import Foundation

enum Gender:String,Codable,CaseIterable {
    case MALE
    case FEMALE
    case OTHER
    
    func displayName()->String{
        self.rawValue.lowercased().capitalizedFirstLetter
    }
}

enum  ActiveProfile:String,Codable {
    case MINDER
    case FINDER
}

enum  ProfileCompletionStatus:String,Codable {
    case INCOMPLETE
    case COMPLETED
}

enum  ApprovalStatus:String,Codable {
    case  REVIEW_REQUIRED
    case  IN_REVIEW
    case  APPROVED
    case  CHANGE_REQUESTED
    case  REJECTED
}

enum  MinderAvailableStatus:String,Codable {
    case  AVAILABLE
    case  NOT_AVAILABLE
}

enum  AdminUserRole:String,Codable {
    case SUPER_USER
    case USER
}


enum  DeviceType:String,Codable {
    case ANDROID
    case IOS
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
    
    static func initialize(stringValue: String?)-> UserDocumentType?{
        switch(stringValue){
        case UserDocumentType.NATIONAL_ID.description:
            return .NATIONAL_ID
        case UserDocumentType.PASSPORT.description:
            return .PASSPORT
        case UserDocumentType.DRIVING_LICENSE.description:
            return .DRIVING_LICENSE
        case UserDocumentType.OTHER.description:
            return .OTHER
        default:
            return nil
        }
        
    }
}
enum PetSizePreferences : String,Codable,CaseIterable{
    case SMALL
    case MEDIUM
    case LARGE
}
