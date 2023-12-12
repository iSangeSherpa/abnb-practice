//
//  public-user+dto.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 12/12/2022.
//

import Foundation


struct AddressModel :Codable {
    var latitude:Double
    var longitude:Double
    var name:String
    
    func toDomain() -> AddressEntity {
        return AddressEntity(
            name: name,
            longitude: longitude,
            latitude: latitude
        )
    }
}

struct FinderProfilePeekModel : Codable{
    var averageRating: Float
    var totalRatings: Int
    var completionStatus: ProfileCompletionStatus
    var approvalStatus: ApprovalStatus
    
    func toDomain() -> FinderProfilePeek{
        return FinderProfilePeek(
            averageRating: averageRating,
            totalRatings: totalRatings,
            completionStatus: completionStatus,
            approvalStatus: approvalStatus
        )
        
    }
}

struct MinderProfilePeekModel :Codable {
    var availableStatus: AvailableStatus
    var approvalStatus: ApprovalStatus
    var petSizePreferences: [PetSizePreferences]
    var petBehaviorPreferences: [String]
    var averageRating: Float
    var totalRatings: Int
    
    func toDomain() -> MinderProfilePeek{
        return MinderProfilePeek(
            availableStatus: availableStatus,
            approvalStatus: approvalStatus,
            petSizePreferences: petSizePreferences,
            petBehaviorPreferences: petBehaviorPreferences,
            averageRating: averageRating,
            totalRatings: totalRatings
        )
    }
}

struct PublicUserModel :Codable  {
    var id: String
    var email: String
    var fullName: String?
    var phoneNumber: String?
    let hidePhoneNumber : Bool?
    var active: Bool
    var emailVerified: Bool
    var phoneVerified: Bool
    var activeProfile: ActiveProfile?
    var bio: String?
    var dob: String?
    var image: String?
    var gender: Gender?
    var address: AddressModel?
    var minderProfile: MinderProfilePeekModel?
    var finderProfile: FinderProfilePeekModel?
    var legalDocuments : [DocumentDetails]?
    
    var hasVerifiedDocuments : Bool {
        return legalDocuments?.filter{$0.approvalStatus == .APPROVED}.count ?? 0 > 0
    }
    
    func toDomain() -> PublicUser {
        
        return PublicUser(
            id: id,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber,
            hidePhoneNumber: hidePhoneNumber,
            active: active,
            emailVerified: emailVerified,
            phoneVerified: phoneVerified,
            activeProfile: activeProfile,
            bio: bio,
            dob: dob,
            image: image,
            gender: gender,
            address: address?.toDomain(),
            minderProfile: minderProfile?.toDomain(),
            finderProfile: finderProfile?.toDomain(),
            hasVerifiedDocuments: hasVerifiedDocuments
        )
    }
}
