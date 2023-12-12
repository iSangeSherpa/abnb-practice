//
//  HomeRepository.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 22/11/2022.
//

import Foundation
import RxSwift
import Alamofire

protocol HomeRepository {
    func getReceivedMindingRequests() -> Single<[MindingRequestDetails]>
    func getReceivedMindingRequestDetails(requestId : String) -> Single<MindingRequestDetails>
    func clockOut(requestId : String)->Single<MindingRequestDetails>
    func clockIn(requestId : String)->Single<MindingRequestDetails>
    func getNearbyUsers(activeProfiles: [ActiveProfile]?,latitude:Float,longitude:Float,maxDistance:Float,minderWithPet : String?, gender: Gender?)->Single<[Profile]>
    func postUserReview(requestId: String, toUserId: String,rating: Int, message:String, images:[String])->Single<IdResponse>
    func postPetReview(requestId: String, toPetId: String,rating: Int, message:String, images:[String])->Single<IdResponse>
}
class HomeRepositoryImpl : HomeRepository {
    
    func getReceivedMindingRequests() -> Single<[MindingRequestDetails]> {
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getReceivedMindingRequests(userId: userId).map{ $0.data }
    }
    
    func getReceivedMindingRequestDetails(requestId : String) -> Single<MindingRequestDetails> {
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getReceivedMindingRequestDetails(userId: userId,requestId: requestId).map{ $0.data }
    }
    
    func getSentMindingRequests() -> Single<[MindingRequestDetails]> {
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getSentMindingRequests(userId: userId).map{ $0.data }
    }
    func getSentMindingRequestDetails(requestId : String) -> Single<MindingRequestDetails> {
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getSentMindingRequestDetails(userId: userId,requestId: requestId).map{ $0.data }
    }
    
    func clockIn(requestId: String)->Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.clockIn(userId: userId,requestId: requestId).map{$0.data}
    }
    
    func clockOut(requestId: String)->Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.clockOut(userId: userId,requestId: requestId).map{$0.data}
    }
    
    func acceptMindingRequest(requestId : String)->Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        let params = ["status" : RequestStatus.ACCEPTED.rawValue]
        return ApiService.updateReceivedMindingRequest(userId: userId,requestId: requestId,param: params).map{$0.data}
    }
    
    func declineMindingRequest(requestId : String)->Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        let params = ["status" : RequestStatus.REJECTED.rawValue]
        return ApiService.updateReceivedMindingRequest(userId: userId,requestId: requestId,param: params).map{$0.data}
    }
    func cancelMindingRequest(requestId : String)->Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        let params = ["status" : RequestStatus.CANCELLED_BY_MINDER.rawValue]
        return ApiService.updateReceivedMindingRequest(userId: userId,requestId: requestId,param: params).map{$0.data}
    }
    
    func cancelBooking(requestId : String)->Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        let params = ["status" : RequestStatus.CANCELLED.rawValue]
        return ApiService.cancelBooking(userId: userId,requestId: requestId,param: params).map{$0.data}
    }
    
    func createRequest(minderUserId:String, from:String, to:String, perHourRate:Float, message:String, currencyId:String,pets:[Pet]) -> Single<MindingRequestDetails>{
        let userId = SessionManager.shared.userId ?? ""
        let params : Parameters = [
            "minderUserId" : minderUserId,
            "from":from,
            "to":to,
            "perHourRate" : perHourRate,
            "message":message,
            "currencyId":currencyId,
            "pets": pets.map{["id":$0.id]}
        ]
        return ApiService.createRequest(userId : userId, param : params).map{$0.data}
    }
    
    //Map Tab
    func getNearbyUsers(activeProfiles: [ActiveProfile]? = nil,latitude:Float,longitude:Float,maxDistance:Float,minderWithPet : String?, gender: Gender?)->Single<[Profile]>{
        var param : Parameters = [
            "latitude" : latitude.asString(),
            "longitude" : longitude.asString(),
            "maxDistance" : maxDistance.asString()
        ]
        
        if let activeProfiles = activeProfiles{
            _ = activeProfiles.map{param["activeProfiles"] = $0.rawValue}
        }else{
            switch(SessionManager.shared.userType){
            case .MINDER:
                param["activeProfiles"] = [ActiveProfile.FINDER.rawValue,ActiveProfile.BOTH.rawValue]
            case .FINDER:
                param["activeProfiles"] = [ActiveProfile.MINDER.rawValue,ActiveProfile.BOTH.rawValue]
            case .BOTH:
                param["activeProfiles"] = [ActiveProfile.MINDER.rawValue,ActiveProfile.FINDER.rawValue,ActiveProfile.BOTH.rawValue]
            case .none:
                break
            }
        }
        
    
        if let gender = gender{
            param["gender"] = gender.rawValue
        }
        
        if let minderWithPet  = minderWithPet{
            param["minderWithPet"] = minderWithPet
        }
        
        
        return ApiService.getNearbyUsers(param: param).map{$0.data}
    }
    
    //Reviews
    func postUserReview(requestId: String, toUserId: String, rating: Int, message:String, images:[String]) -> Single<IdResponse> {
        let param :Parameters = [
            "rating" : rating,
            "message" : message,
            "toUserId" : toUserId,
            "images" : images
        ]
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.postReview(userId: userId, requestId: requestId,param: param).map{$0.data}
    }
    
    func postPetReview(requestId: String, toPetId: String,rating: Int, message:String, images:[String]) -> Single<IdResponse> {
        let param : Parameters = [
            "rating" : rating,
            "message" : message,
            "toPetId" : toPetId,
            "images" : images
        ]
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.postReview(userId: userId, requestId: requestId,param: param).map{$0.data}
    }
    
}
