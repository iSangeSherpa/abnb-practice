//
//  MindingRequestResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 01/12/2022.
//

import Foundation
enum MindingRequestType{
    case ACTIVE
    case REQUEST
    case BOOKING
    case COMPLETED
}
struct MindingRequestDetails : Codable{
    let id : String
    let from : String
    let to : String
    let status : RequestStatus
    let perHourRate : Float
    let message : String
    let currencyId : String
    let finderUserId : String
    let minderUserId : String
    let currency : Currency
    let pets : [PetDetails]
    let addressName : String?
    let finder : Profile?
    let minder : Profile?
    let createdAt : String
    let updatedAt: String
    let entry : Entry?
    let reviews : [Reviews]?
    
    func getMindingRequestType()->MindingRequestType{
        if(entry == nil){
            return .REQUEST
        }else{
            if(entry!.clockIn != nil) && (entry!.clockOut == nil){
                return .ACTIVE
            }else if((entry!.clockIn == nil) && (entry!.clockOut == nil)){
                return .BOOKING
            }
                return .COMPLETED
        }
    }
}

struct Profile : Codable{
    let id : String
    let fullName : String?
    let phoneNumber : String?
    let hidePhoneNumber : Bool?
    let address : AddressDetails?
    let activeProfile : ActiveProfile
    let image : String?
    let minderProfile : MinderProfileDetails?
    let finderProfile : FinderProfileDetails?
    let receivedReviews : [Reviews]?
    let legalDocuments : [DocumentDetails]?
    
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
    
    var hasVerifiedDocuments : Bool {
        return legalDocuments?.filter{$0.approvalStatus == .APPROVED}.count ?? 0 > 0
    }
    
    func isProfileVerified()->Bool{
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

struct Entry : Codable{
    let id : String
    let clockIn : String?
    let clockOut : String?
    let mindingRequestId : String
    let createdAt : String
    let updatedAt : String
}
