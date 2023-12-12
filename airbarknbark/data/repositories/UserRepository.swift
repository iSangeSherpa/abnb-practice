//
//  HomeRepository.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/11/2022.
//

import Foundation
import RxSwift
import Alamofire
import SVProgressHUD
import FirebaseMessaging

protocol UserRepository{
    func login(email:String, password:String) -> Single<LoginResponse>
    func logout() -> Single<Empty>
    func createUser(email:String, password:String)-> Single<RegisterDetails>
    func verifyEmail(email:String, token: String) -> Single<String>
    func updateUserDetails(
        fullName:String?,
        image:String?,
        shortBio : String?,
        activeProfile: String?,
        dob:String?,
        phoneNumber:String?,
        showMyNumber:Bool?,
        emergencyContact:String?,
        gender:String?,
        type:UserUpdateType,
        availableStatus:AvailableStatus?
    ) -> Single<UserDetails>
    func updatePassword(password : String, currentPassword : String) -> Single<UserDetails>
    func getUserDetails(userId : String)->Single<UserDetails>
    func updateAddress(addressDetail : Address) -> Single<AddressDetails>
    func getAddress() -> Single<AddressDetails>
    func getVehicleDetails() -> Single<[VehicleDetails]>
    func removeVehicle(vehicleId:String) -> Single<VehicleDetails>
    func updateVehicleDetail(vehicle : VehicleLocal) -> Single<VehicleDetails>
    func getAllDocuments() -> Single<[DocumentDetails]>
    func updateDocumentDetail(document : DocumentLocal) -> Single<DocumentDetails>
    func getMinderProfileById(minderUserId : String)->Single<MinderProfileDetails>
    func updateMinderProfile(minderProfileRequestParams : Parameters) -> Single<MinderProfileDetails>
    func getAllCurrency() -> Single<[Currency]>
    func uploadFcmTokenIfNecessary() -> Completable
    func reportUser(message: String, toUserId: String)->Single<IdResponse>
    func resetPassword(password : String, email: String, token: String)->Single<String>
    func passwordResetToken(email: String)->Single<String>
    func checkPasswordResetToken(email: String, token: String) -> Single<String>
    func resendEmailVerificationToken(email: String) -> Single<String>
    func deleteAccount() -> Single<Empty>
    func getBlockedUsers() -> Single<[BlockedUser]>
    func blockUser(toUserId : String) -> Single<String>
    func unblockUser(toUserId : String) -> Single<String>
    func getReceivedReviews() -> Single<[Reviews]>
    func getAppVersion() -> Single<AppVersion>
}

class UserRepositoryImpl : UserRepository{
    
    let sessionManager = SessionManager.shared
    
    func login(email: String, password: String) -> Single<LoginResponse>{
        let params  = ["email":email,"password":password]
        return ApiService.newSession(param: params)
    }
    
    func logout()->Single<Empty>{
        let sessionId = SessionManager.shared.sessionId ?? ""
        let userId = SessionManager.shared.sessionId ?? ""
        return ApiService.deleteSession(userId: userId, sessionId: sessionId)
    }
    
    func createUser(email:String,password:String) -> Single<RegisterDetails> {
        let params = ["email":email, "password": password]
        return ApiService.createUser(param: params)
            .map{ $0.data }
    }
    
    func verifyEmail(email: String, token: String) -> Single<String> {
        let params = ["email":email, "token":token]
        return ApiService.verifyEmail(param:params).map {
            $0.data
        }
    }
    func resendEmailVerificationToken(email: String) -> Single<String> {
        let params = ["email":email]
        return ApiService.resendEmailVerificationToken(param:params).map {
            $0.data
        }
    }
    
    func updateUserDetails(
        fullName:String? = nil,
        image:String? = nil,
        shortBio : String? = nil,
        activeProfile: String? = nil,
        dob:String? = nil,
        phoneNumber:String? = nil,
        showMyNumber:Bool? = nil,
        emergencyContact:String? = nil,
        gender:String? = nil,
        type:UserUpdateType = UserUpdateType.UPDATE,
        availableStatus:AvailableStatus? = nil
    ) -> Single<UserDetails> {
        
        var params : Parameters = [:]
        if(fullName != nil){
            params["fullName"] = fullName
        }
        if(image != nil){
            params["image"] = image
        }
        if(shortBio != nil){
            params["bio"] = shortBio
        }
        if(activeProfile != nil){
            params["activeProfile"] = activeProfile
        }
        if(dob != nil){
            params["dob"] = dob
        }
        if(dob != nil){
            params["hidePhoneNumber"] = !(showMyNumber ?? true)
        }
        if(phoneNumber != nil){
            params["phoneNumber"] = phoneNumber
        }
        if(emergencyContact != nil){
            params["emergencyPhoneNumber"] = emergencyContact
        }
        if(availableStatus != nil){
            params["availableStatus"] = availableStatus?.rawValue ?? ""
        }
        
        if(gender != nil){
            params["gender"] = gender
        }
       
        params["type"] = type.rawValue
        
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.updateUser(id: userId, param: params)
            .map {
                $0.data
            }
    }
    func getUserDetails(userId : String = SessionManager.shared.userId ?? "")->Single<UserDetails>{
        return ApiService.getUser(id: userId)
            .map {
                $0.data
            }.do(onSuccess: { userInfo in
                SessionManager.shared.setActiveSubscription(productdId: userInfo.subscription?.productId ?? "")
            })
    }
    
    func updateAddress(addressDetail : Address) -> Single<AddressDetails>{
        let params = [
            "name":addressDetail.name,
            "latitude":"\(String(format:"%.3f",addressDetail.lat))",
            "longitude":"\(String(format:"%.3f",addressDetail.lang))"
        ]
        
        let userId = SessionManager.shared.userId ?? ""
        
        return ApiService.updateAddress(userId: userId, param: params).map{ $0.data }
    }
    
   
    func getAddress() -> Single<AddressDetails>{
        let userId = SessionManager.shared.userId ?? ""
        
        return ApiService.getAddress(userId: userId)
            .map{ $0.data }
    }
    
    func removeAddress() -> Single<String> {
        let userId = SessionManager.shared.userId ?? ""
        
        return ApiService.removeAddress(userId: userId)
            .map{ $0.data }
    }
    
    func getVehicleDetails() -> Single<[VehicleDetails]> {
        let userId = SessionManager.shared.userId ?? ""
        
        return ApiService.getVehicleDetails(userId: userId)
            .map{ $0.data }
    }
    
    func updateVehicleDetail(vehicle:VehicleLocal)->Single<VehicleDetails>{
        let params : Parameters = [
            "name": vehicle.vehicleName,
            "numberPlate" : vehicle.numberPlate,
            "issuePlace" : vehicle.issuePlace,
            "images": vehicle.imagesString ?? []
        ]
        
        let userId = SessionManager.shared.userId ?? ""
        
        return  ApiService.updateVehicleDetail(userId: userId, param: params).map{
            $0.data
        }
    }
    func removeVehicle(vehicleId : String)->Single<VehicleDetails>{
        let userId = SessionManager.shared.userId ?? ""
        
        return  ApiService.deleteVehicle(userId: userId, vehicleId:vehicleId).map{
            $0.data
        }
    }
    
    func getAllDocuments() -> Single<[DocumentDetails]>{
        let userId = SessionManager.shared.userId ?? ""
        return  ApiService.getAllDocument(userId: userId).map{
            $0.data
        }
    }
    
    func createDocument(document: DocumentLocal) -> Single<DocumentDetails> {
        let params : Parameters = [
            "type": document.documentType,
            "documentId": document.idNumber,
            "issuePlace":document.issuePlace,
            "files": document.imagesString ?? []
        ]
        
        let userId = SessionManager.shared.userId ?? ""
        
        return  ApiService.createDocument(userId: userId, param: params).map{
            $0.data
        }
    }
    
    func updateDocumentDetail(document: DocumentLocal) -> Single<DocumentDetails> {
        let params : Parameters = [
            "type": document.documentType,
            "documentId": document.idNumber,
            "issuePlace":document.issuePlace,
            "files": document.imagesString ?? []
        ]
        
        let userId = SessionManager.shared.userId ?? ""
        
        return  ApiService.updateDocumentDetail(userId: userId,documentId:document.id, param: params).map{
            $0.data
        }
    }
    
    func removeDocument(documentId: String) -> Single<IdResponse>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.deleteDocument(userId: userId, documentId: documentId).map { $0.data }
    }
    
    func updateMinderProfile(minderProfileRequestParams : Parameters)->Single<MinderProfileDetails>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.updateMinderProfile(userId: userId,param: minderProfileRequestParams).map{$0.data}
    }
    
    func getMinderProfileDetails()->Single<MinderProfileDetails>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getMinderProfileDetails(userId: userId).map{$0.data}
    }
    
    func getMinderProfileById(minderUserId : String)->Single<MinderProfileDetails>{
        return ApiService.getMinderProfileDetails(userId: minderUserId).map{$0.data}
    }
    func updatePassword(password: String, currentPassword: String) -> Single<UserDetails> {
        let params = ["password" : password, "currentPassowrd" : currentPassword]
        let userID = SessionManager.shared.userId ?? ""
        return ApiService.updateUser(id: userID, param: params).map { $0.data }
    }
    
    func resetPassword(password : String, email: String, token: String) -> Single<String>{
        let params = ["password" : password, "token" : token, "email": email]
        return ApiService.resetPassword(param: params).map { $0.data }
    }
    
    func checkPasswordResetToken(email: String, token: String) -> Single<String>{
        let params = ["token" : token, "email": email]
        return ApiService.checkPasswordResetToken(param: params).map { $0.data }
    }
    
    func passwordResetToken(email: String) -> Single<String>{
        let params = ["email": email]
        return ApiService.passwordResetToken(param: params).map { $0.data }
    }
    
    func getAllCurrency() -> Single<[Currency]> {
        return ApiService.getCurrencies().map{$0.data}
    }
    
    func uploadFcmTokenIfNecessary() -> Completable{
        
        if(!SessionManager.shared.isLoggedIn){
            return Completable.empty()
        }
        
        guard let currentToken = Messaging.messaging().fcmToken else{
            return .empty()
        }
        
        let lastUplaodedToken = sessionManager.lastFcmToken
       
        if(lastUplaodedToken == currentToken){
            return Completable.empty()
        }
        
        let params : Parameters = [
            "token" :currentToken,
            "deviceType": DeviceType.IOS.rawValue
        ]
        
       return ApiService.updateFcmToken(userId: sessionManager.userId!,param: params)
            .asCompletable()
    }
    
    func reportUser(message: String, toUserId : String) -> Single<IdResponse>{
        let param : Parameters = [
            "message" : message,
            "reportedToUserId" : toUserId
        ]
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.reportUser(userId : userId, param: param).map{$0.data}
    }
    
    func getReceivedReviews() -> Single<[Reviews]>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getReceivedReviews(userId : userId).map{$0.data}
    }
    
    func blockUser(toUserId : String) -> Single<String>{
        let param : Parameters = [
            "blockedToUserId" : toUserId
        ]
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.blockUser(userId : userId, param: param).map{$0.data}
    }
    
    func getBlockedUsers() -> Single<[BlockedUser]>{
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.getBlockedUsers(userId : userId).map{$0.data}
    }
    
    func unblockUser(toUserId : String) -> Single<String>{
        let param : Parameters = [
            "unblockedToUserId" : toUserId
        ]
        let userId = SessionManager.shared.userId ?? ""
        return ApiService.unblockUser(userId : userId, param: param).map{$0.data}
    }
    
    func deleteAccount()->Single<Empty>{
        let sessionId = SessionManager.shared.sessionId ?? ""
        let userId = SessionManager.shared.sessionId ?? ""
        return ApiService.deleteAccount(userId: userId, sessionId: sessionId)
    }
    
    func getAppVersion()->Single<AppVersion>{
        return ApiService.getLatestVersion().map{
            $0.data
        }
    }
}
