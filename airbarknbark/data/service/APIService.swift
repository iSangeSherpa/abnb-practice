//
//  APIService.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/11/2022.
//

import Foundation
import Alamofire
import RxSwift

func defaultHeaders() -> HTTPHeaders {
    
    return   [
        .contentType("application/json"),
        .authorization(bearerToken: SessionManager.shared.accessToken ?? ""),
        .accept("application/json")
    ]
}


struct ApiService{
    
    private init(){
        
    }
    
    static func createUser(param:Encodable) -> Single<BaseResponse<RegisterDetails>>{
        return AF.post("/users",body: param)
    }
    
    static func getUser(id:String) -> Single<BaseResponse<UserDetails>>{
        return  AF.get("/users/\(id)")
    }
    
    static func updateUser(id:String, param:Parameters) -> Single<BaseResponse<UserDetails>>{
        return  AF.patch("/users/\(id)", body:param )
    }
    
    static func updateFcmToken(userId:String, param:Parameters) -> Single<Empty>{
        return AF.post("/users/\(userId)/sessions/fcm-tokens", body: param)
    }
    
    static func updateAddress(userId:String,param:Parameters) -> Single<BaseResponse<AddressDetails>>{
        AF.post("/users/\(userId)/address", body:param)
    }
    static func getAddress(userId:String) -> Single<BaseResponse<AddressDetails>>{
        AF.get("/users/\(userId)/address")
    }
    
    static func removeAddress(userId:String) -> Single<BaseResponse<String>>{
        AF.delete("/users/\(userId)/address")
    }

    static func verifyEmail(param:Encodable) -> Single<BaseResponse<String>> {
        AF.post("/users/verify-email",body: param)
    }
    
    static func resendEmailVerificationToken(param:Encodable) -> Single<BaseResponse<String>> {
        AF.post("/users/email-verification-token",body: param)
    }
    
    static func newSession(param:Encodable) -> Single<LoginResponse> {
        AF.post("/users/sessions",body: param)
    }
    
    static func deleteSession(userId:String, sessionId: String) -> Single<Empty>{
        AF.delete("/users/\(userId)/sessions/\(sessionId)")
    }
    
    static func deleteAccount(userId:String, sessionId: String) -> Single<Empty>{
        AF.post("/users/\(userId)/sessions/account-delete")
    }
    
    static func getAlBreeds() -> Single<BaseResponse<[BreedModel]>>{
        AF.get("/breeds/")
    }
    
    static func createNewBreed(param:Parameters) -> Single<BaseResponse<BreedModel>>{
        AF.post("/breeds", body: param)
    }
    
    static func getAllPets(userId : String) -> Single<BaseResponse<[Pet]>> {
        AF.get("/users/\(userId)/pets")
    }

    static func createNewPet(userId:String, param:Parameters) -> Single<BaseResponse<PetDetails>>{
        AF.post("/users/\(userId)/pets/", body: param)
    }
    
    static func updatePet(userId:String, petId:String, param:Parameters) -> Single<BaseResponse<PetDetails>>{
        AF.patch("/users/\(userId)/pets/\(petId)", body: param)
    }
    
    static func deletePet(userId:String, petId:String) -> Single<BaseResponse<IdResponse>>{
        AF.delete("/users/\(userId)/pets/\(petId)")
    }
    
    static func getAllPets(userId:String) -> Single<BaseResponse<[PetDetails]>>{
        AF.get("/users/\(userId)/pets")
    }

    static func getPresignedUrl(fileName:String, type:String) -> Single<BaseResponse<FileUploadDetails>>{
        AF.get("/put-url/\(fileName)",param: ["type" : type])
    }
    
    static func uplaodFile(url:String, data:Data) -> Single<Empty>{
        AF.put(url,body: data)
    }
    
    static func getVehicleDetails(userId:String) -> Single<BaseResponse<[VehicleDetails]>>{
        AF.get("/users/\(userId)/vehicles")
    }

    static func updateVehicleDetail(userId:String, param:Parameters) -> Single<BaseResponse<VehicleDetails>>{
        AF.post("/users/\(userId)/vehicles",body: param)
    }
    static func deleteVehicle(userId:String, vehicleId:String) -> Single<BaseResponse<VehicleDetails>>{
        AF.delete("/users/\(userId)/vehicles/\(vehicleId)")
    }
    
    static func getAllDocument(userId:String) -> Single<BaseResponse<[DocumentDetails]>>{
        AF.get("/users/\(userId)/legal-documents")
    }
    static func createDocument(userId:String, param:Parameters) -> Single<BaseResponse<DocumentDetails>>{
        AF.post("/users/\(userId)/legal-documents",body: param)
    }
    static func updateDocumentDetail(userId:String,documentId:String, param:Parameters) -> Single<BaseResponse<DocumentDetails>>{
        AF.patch("/users/\(userId)/legal-documents/\(documentId)",body: param)
    }
    static func deleteDocument(userId:String, documentId:String) -> Single<BaseResponse<IdResponse>>{
        AF.delete("/users/\(userId)/legal-documents/\(documentId)")
    }
    static func updateMinderProfile(userId:String, param:Parameters) -> Single<BaseResponse<MinderProfileDetails>>{
        AF.patch("/users/\(userId)/minder-profile",body: param)
    }
    static func getMinderProfileDetails(userId:String) -> Single<BaseResponse<MinderProfileDetails>>{
        AF.get("/users/\(userId)/minder-profile")
    }
    
    static func getCurrencies() -> Single<BaseResponse<[Currency]>> {
        AF.get("/currencies")
    }
    
    //Home screen APIs
    static func getReceivedMindingRequests(userId:String) -> Single<BaseResponse<[MindingRequestDetails]>> {
        AF.get("/users/\(userId)/minding-requests/received")
    }
    static func getReceivedMindingRequestDetails(userId:String, requestId: String) -> Single<BaseResponse<MindingRequestDetails>> {
        AF.get("/users/\(userId)/minding-requests/received/\(requestId)")
    }
    static func createRequest(userId:String, param : Parameters) -> Single<BaseResponse<MindingRequestDetails>> {
        AF.post("/users/\(userId)/minding-requests/sent",body: param)
    }
    static func getSentMindingRequests(userId:String) -> Single<BaseResponse<[MindingRequestDetails]>> {
        AF.get("/users/\(userId)/minding-requests/sent")
    }
    static func getSentMindingRequestDetails(userId:String, requestId: String) -> Single<BaseResponse<MindingRequestDetails>> {
        AF.get("/users/\(userId)/minding-requests/sent/\(requestId)")
    }
    static func clockIn(userId:String, requestId: String)->Single<BaseResponse<MindingRequestDetails>>{
        AF.post("/users/\(userId)/minding-requests/received/\(requestId)/clock-in")
    }
    static func clockOut(userId:String, requestId: String)->Single<BaseResponse<MindingRequestDetails>>{
        AF.post("/users/\(userId)/minding-requests/received/\(requestId)/clock-out")
    }
    static func updateReceivedMindingRequest(userId:String, requestId: String,param: Parameters)->Single<BaseResponse<MindingRequestDetails>>{
        AF.patch("/users/\(userId)/minding-requests/received/\(requestId)",body:param )
    }
    static func cancelBooking(userId:String, requestId: String,param: Parameters)->Single<BaseResponse<MindingRequestDetails>>{
        AF.patch("/users/\(userId)/minding-requests/sent/\(requestId)",body:param )
    }
    
    
    //Conversation API
    static func startConversation(userId:String,param: Parameters)->Single<BaseResponse<ConversationModel>>{
        AF.post("/users/\(userId)/conversations",body:param )
    }
    

    static func sendNewMessage(userId:String,conversationId : String, param: Parameters)->Single<BaseResponse<ConversationMessageModel>>{
        AF.post("/users/\(userId)/conversations/\(conversationId)/messages" , body: param)
    }
    
    static func getMessagesForConversation(userId:String, conversationId : String)->Single<BaseResponse<[ConversationMessageModel]>>{
        AF.get("/users/\(userId)/conversations/\(conversationId)/messages" )
    }
    
    static func getAllConversations(userId:String)->Single<BaseResponse<[ConversationModel]>>{
        AF.get("/users/\(userId)/conversations" )
    }
    
    static func updateSeenStatus(userId:String, conversationId : String)->Single<BaseResponse<ConversationMessageModel>>{
        AF.get("/users/\(userId)/conversations/\(conversationId)/updateSeenStatus" )
    }
    
    static func getNearbyUsers(param : Parameters)->Single<BaseResponse<[Profile]>>{
        AF.get("/users",param :param)
    }
    
    //Post Reviews
    static func postReview(userId : String, requestId : String, param : Parameters)->Single<BaseResponse<IdResponse>>{
        AF.post("/users/\(userId)/minding-requests/\(requestId)/reviews", body: param)
    }
    
    //Notification API
    static func getAllNotification(userId : String)->Single<BaseResponse<[NotificationModel]>>{
        AF.get("/users/\(userId)/notifications")
    }
    static func markNotificationAsSeen(userId : String, notificationId : String)->Single<BaseResponse<NotificationModel>>{
        AF.patch("/users/\(userId)/notifications/\(notificationId)",body: ["isSeen":true])
    }
    static func deleteNotification(userId : String, notificationId : String)->Single<BaseResponse<NotificationModel>>{
        AF.delete("/users/\(userId)/notifications/\(notificationId)")
    }
    
    static func reportUser(userId : String, param : Parameters)->Single<BaseResponse<IdResponse>>{
        AF.post("/users/\(userId)/reports", body: param)
    }
    
    static func getReceivedReviews(userId : String)->Single<BaseResponse<[Reviews]>>{
        AF.get("/users/\(userId)/reviews/received")
    }
    
    //Block/Unblock User
    
    static func getBlockedUsers(userId : String)->Single<BaseResponse<[BlockedUser]>>{
        AF.get("/users/\(userId)/block")
    }
    static func blockUser(userId : String, param : Parameters)->Single<BaseResponse<String>>{
        AF.post("/users/\(userId)/block", body: param)
    }
    
    static func unblockUser(userId : String, param : Parameters)->Single<BaseResponse<String>>{
        AF.post("/users/\(userId)/unblock", body: param)
    }
    
    //Reset Password
    static func resetPassword(param : Parameters)->Single<BaseResponse<String>>{
        AF.post("/users/reset-password", body: param)
    }
    static func checkPasswordResetToken(param : Parameters)->Single<BaseResponse<String>>{
        AF.post("/users/check-password-reset-token", body: param)
    }
    static func passwordResetToken(param : Parameters)->Single<BaseResponse<String>>{
        AF.post("/users/password-reset-token", body: param)
    }

    static func getLatestVersion()->Single<BaseResponse<AppVersion>>{
        AF.get("/app/version")
    }
    
    
    //In app Subscription
    
    static func checkActiveSubscription(userId : String)->Single<BaseResponse<CheckActiveSubscriptionResponse>>{
        AF.get("/subscription/receipt/valid")
    }
    
    static func sendReceiptToServer(userId : String, params : Parameters)->Single<BaseResponse<String>>{
        AF.post("/subscription/ios", body:params)
    }
    
    static func checkForInitialSubscription(userId : String, params : Parameters)->Single<BaseResponse<InitialSubscriptionResponse>>{
        AF.post("/subscription/valid/ios", body:params)
    }
}

