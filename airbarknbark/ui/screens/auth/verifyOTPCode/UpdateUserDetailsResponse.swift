//
//  UpdateUserDetailsResposne.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 22/11/2022.
//

import Foundation
import Differentiator

struct UserDetails : Codable{
    let id : String
    let email : String
    let fullName : String?
    let phoneNumber : String?
    let emergencyPhoneNumber : String?
    let hidePhoneNumber : Bool?
    let active : Bool
    let emailVerified : Bool
    let phoneVerified : Bool
    let activeProfile : ActiveProfile?
    let completionStatus : ProfileCompletionStatus?
    let bio : String?
    let dob : String?
    let gender:Gender?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let minderProfile: MinderProfileDetails?
    let finderProfile: FinderProfileDetails?
    let receivedReviews : [Reviews]?
    let address : AddressDetails?
    let pets : [PetDetails]?
    let legalDocuments : [DocumentDetails]?
    let subscription: SubscriptionDetails?
    
    struct SubscriptionDetails: Codable{
        let purchaseDate : String
        let expiresDate : String
        let productId : String
        let deviceType : DeviceType
        let paymentType : PaymentType

    }

    
    func getAverageRating()->Float{
        var avgRating:Float = 0
        var minderRating: Float = 0
        var finderRating: Float = 0
        if (minderProfile?.averageRating) != nil {
            minderRating = minderProfile?.averageRating ?? 0
        }
        
        if (finderProfile?.averageRating) != nil {
            finderRating = finderProfile?.averageRating ?? 0
        }
        
        if(minderRating == 0){
            avgRating =  finderRating
        }else if (finderRating == 0){
            avgRating =  minderRating
        }else{
            avgRating = (minderRating + finderRating)/2
        }
        return avgRating
    }
}

extension UserDetails{
    
    var isMinderOrFinderProfileIsComplete: Bool{
        get{
            activeProfile != nil &&
            activeProfile == ActiveProfile.FINDER ?
            finderProfile?.completionStatus == .COMPLETED :
            minderProfile?.completionStatus == .COMPLETED
        }
    }
    
    var isGeneralProfileComplete:Bool{
        get{
            return completionStatus == .COMPLETED
        }
    }
    
    var hasProfileToComplete:Bool{
        get{
            return !(isMinderOrFinderProfileIsComplete && isGeneralProfileComplete)
        }
    }
    
    var hasVerifiedDocuments : Bool {
        return legalDocuments?.filter{$0.approvalStatus == .APPROVED}.count ?? 0 > 0
    }
    
    func isProfileVerified()->Bool{
        guard let activeProfile = activeProfile else{
            return false;
        }
        
        switch(activeProfile){
            
        case .MINDER:
            return minderProfile?.approvalStatus == .APPROVED && hasVerifiedDocuments
        case .FINDER:
            return finderProfile?.approvalStatus == .APPROVED && hasVerifiedDocuments
        case .BOTH:
           return minderProfile?.approvalStatus == .APPROVED && finderProfile?.approvalStatus == .APPROVED && hasVerifiedDocuments
        }
    }
    
}

struct FinderProfileDetails : Codable{
    let userId : String
    let completionStatus : ProfileCompletionStatus
    let approvalStatus : ApprovalStatus
    let availableStatus : AvailableStatus?
    let createdAt : String
    let updatedAt : String
    let receivedReviews : [Reviews]?
    let averageRating : Float?
}

struct VehicleDetails : Codable, Equatable, IdentifiableType{
    let id : String
    let name : String
    let numberPlate : String
    let issuePlace :String
    let images : [String]
    let approvalStatus : ApprovalStatus
    let userId : String
    let createdAt : String
    let updatedAt : String
    
    var identity: String{
        return id
    }
}
