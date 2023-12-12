//
//  MinderProfileDetails.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/11/2022.
//

import Foundation

struct MinderProfileDetails : Codable{
    let userId : String
    let completionStatus : ProfileCompletionStatus
    let availableStatus : MinderAvailableStatus
    let approvalStatus : ApprovalStatus
    let traveling : Bool?
    let perHourRate : Float?
    let yearsOfExperience : Float?
    let petSizePreferences : [PetSizePreferences]
    let petBehaviorPreferences : [String]
    let currencyId : String?
    let minderAvailability : [MinderAvailability]?
    let breedPreferences : [Breed]?
    let vehicles : [VehicleDetails]?
    let receivedReviews : [Reviews]?
    let averageRating : Float?
    let totalRating : Float?
    
    func getAvailabilityStatus() -> Bool { return availableStatus  == MinderAvailableStatus.AVAILABLE}
}

struct MinderAvailability : Codable{
    let from : String
    let to : String
    let dayOfWeek : String
}

