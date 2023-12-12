//
//  SessionManager.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 22/11/2022.
//

import Foundation
import RxRelay
import RxSwift

fileprivate let ACCESS_TOKEN = "ACCESS_TOKEN"
fileprivate let REFRESH_TOKEN = "REFRESH_TOKEN"
fileprivate let EMAIL = "EMAIL"
fileprivate let FULL_NAME = "FULL_NAME"
fileprivate let USER_ID = "USER_ID"
fileprivate let USER = "USER"
fileprivate let FCM_TOKEN = "FCM_TOKEN"
fileprivate let SESSION_ID = "SESSION_ID"
fileprivate let ACTIVE_PROFILE = "ACTIVE_PROFILE"
fileprivate let AVAILABLE_STATUS = "AVAILABLE_STATUS"
fileprivate let FINDER_AVAILABLE_STATUS = "FINDER_AVAILABLE_STATUS"
fileprivate let NOTIFICATION_ENABLED = "NOTIFICATION_ENABLED"
fileprivate let CHAT_BADGE_COUNT = "CHAT_BADGE_COUNT"
fileprivate let NOTIFICATION_BADGE_COUNT = "NOTIFICATION_BADGE_COUNT"
fileprivate let SUBSCRIPTION_PRODUCT_LIST = "SUBSCRIPTION_PRODUCT_LIST"
fileprivate let ACTIVE_SUBSCRIPTION = "ACTIVE_SUBSCRIPTION"

enum SessionUpdateEvent{
    case LoggedOut
    case LoggedIn(userId:String, sessionId:String, accessToken:String)
}

typealias SessionUpdateListner = (SessionUpdateEvent)->Void

class SessionManager {
    
    var sessionUpdateListners: [String:SessionUpdateListner] = [:]
    
    func addSessionUpdateListner(key:String, listner: @escaping SessionUpdateListner){
        sessionUpdateListners[key] = listner
    }
    
    func removeSessionUpdateListner(key:String){
        sessionUpdateListners.removeValue(forKey: key)
    }
    
    static let shared = SessionManager()
   
    var notificationEnabled: Bool?{
        get {
            return UserDefaults.standard.codableObject(dataType: Bool.self, key: NOTIFICATION_ENABLED)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: NOTIFICATION_ENABLED)
        }
    }
    var accessToken: String?{
        get{
            return UserDefaults.standard.string(forKey: ACCESS_TOKEN)
        }
            set{
            UserDefaults.standard.setValue(newValue, forKey: ACCESS_TOKEN)
        }
    }
    
    var refreshToken: String?{
        get{
            return UserDefaults.standard.string(forKey: REFRESH_TOKEN)
        }
            set{
            UserDefaults.standard.setValue(newValue, forKey: REFRESH_TOKEN)
        }
    }
   
    var fullName: String?{
        return UserDefaults.standard.string(forKey: FULL_NAME)
    }
    var email: String?{
        return UserDefaults.standard.string(forKey: EMAIL)
    }
    
    var userId: String?{
        return UserDefaults.standard.string(forKey: USER_ID)
    }
    
    var sessionId: String?{
        return UserDefaults.standard.string(forKey: SESSION_ID)
    }
    
    var user:UserDetails?{
        get {
            return UserDefaults.standard.codableObject(dataType: UserDetails.self, key: USER)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: USER)
        }
    }
    
    var isLoggedIn : Bool{
        return accessToken != nil && userId != nil && sessionId != nil
    }
    
    var userType : ActiveProfile? {
        get {
            return UserDefaults.standard.codableObject(dataType: ActiveProfile.self, key: ACTIVE_PROFILE)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: ACTIVE_PROFILE)
        }
    }
    var availableStatus : MinderAvailableStatus? {
        get {
            return UserDefaults.standard.codableObject(dataType: MinderAvailableStatus.self, key: AVAILABLE_STATUS)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: AVAILABLE_STATUS)
        }
    }
    
    var finderAvailableStatus : AvailableStatus? {
        get {
            return UserDefaults.standard.codableObject(dataType: AvailableStatus.self, key: FINDER_AVAILABLE_STATUS)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: FINDER_AVAILABLE_STATUS)
        }
    }
    
    var chatBadgeCount : Int? {
        get {
            return UserDefaults.standard.codableObject(dataType: Int.self, key: CHAT_BADGE_COUNT)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: CHAT_BADGE_COUNT)
        }
    }
    
    var notificationBadgeCount : Int? {
        get {
            return UserDefaults.standard.codableObject(dataType: Int.self, key: NOTIFICATION_BADGE_COUNT)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: NOTIFICATION_BADGE_COUNT)
        }
    }
    
    var activeSubscription : SubscriptionModel? {
        get {
            return UserDefaults.standard.codableObject(dataType: SubscriptionModel.self, key: ACTIVE_SUBSCRIPTION)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: ACTIVE_SUBSCRIPTION)
        }
    }
    
    var subscriptionProductList : [SubscriptionModel]? {
        get {
            return UserDefaults.standard.codableObject(dataType: [SubscriptionModel].self, key: SUBSCRIPTION_PRODUCT_LIST)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: SUBSCRIPTION_PRODUCT_LIST)
        }
    }
   
    var userTypeFlow:Observable<ActiveProfile?>{
        get{
            UserDefaults.standard.rx
                .observe(String.self, ACTIVE_PROFILE)
                .map { it in
                    SessionManager.shared.userType
                }
        }
    }
    
    var chatBadgeCountFlow:Observable<Int?>{
        get{
            UserDefaults.standard.rx
                .observe(String.self, CHAT_BADGE_COUNT)
                .map { it in
                    SessionManager.shared.chatBadgeCount
                }
        }
    }
    
    var notificationBadgeCountFlow:Observable<Int?>{
        get{
            UserDefaults.standard.rx
                .observe(String.self, NOTIFICATION_BADGE_COUNT)
                .map { it in
                    SessionManager.shared.notificationBadgeCount
                }
        }
    }
    
    var availableStatusFlow:Observable<MinderAvailableStatus?>{
        get{
            UserDefaults.standard.rx
                .observe(String.self, AVAILABLE_STATUS)
                .map { it in
                    SessionManager.shared.availableStatus
                }
        }
    }
    
    var finderAvailableStatusFlow:Observable<AvailableStatus?>{
        get{
            UserDefaults.standard.rx
                .observe(String.self, FINDER_AVAILABLE_STATUS)
                .map { it in
                    SessionManager.shared.finderAvailableStatus
                }
        }
    }
    
    var subscriptionProductListFlow:Observable<[SubscriptionModel]?>{
        get{
            UserDefaults.standard.rx
                .observe([SubscriptionType].self, SUBSCRIPTION_PRODUCT_LIST)
                .map { it in
                    SessionManager.shared.subscriptionProductList
                }
        }
    }
    
    var activeSubscriptionFlow:Observable<SubscriptionModel?>{
        get{
            UserDefaults.standard.rx
                .observe(SubscriptionType.self, ACTIVE_SUBSCRIPTION)
                .map { it in
                    SessionManager.shared.activeSubscription
                }
        }
    }

    
    var lastFcmToken:String?{
        get {
            return UserDefaults.standard.string(forKey: FCM_TOKEN)
        }
        set{
            UserDefaults.standard.setCodableObject(newValue, forKey: FCM_TOKEN)
        }
    }
    
    public func setActiveSubscription(productdId : String){
        SessionManager.shared.activeSubscription = SessionManager.shared.subscriptionProductList?.filter{
            $0.id == productdId
        }.first
    }
    
    public func saveEmail(email:String){
        UserDefaults.standard.setValue(email.lowercased(), forKey: EMAIL)
    }
    
    public func saveSession(accessToken : String , userId: String, sessionId:String, refreshToken:String){
        UserDefaults.standard.setValue(accessToken, forKey: ACCESS_TOKEN)
        UserDefaults.standard.setValue(userId, forKey: USER_ID)
        UserDefaults.standard.setValue(sessionId, forKey: SESSION_ID)
        UserDefaults.standard.setValue(refreshToken, forKey: REFRESH_TOKEN)
        
        sessionUpdateListners.forEach { (key: String, value: SessionUpdateListner) in
            value(.LoggedIn(userId: userId, sessionId: sessionId, accessToken: accessToken))
        }
    }
    
    public func clearSession(){
        UserDefaults.standard.removeObject(forKey: ACCESS_TOKEN)
        UserDefaults.standard.removeObject(forKey: FULL_NAME)
        UserDefaults.standard.removeObject(forKey: USER_ID)
        UserDefaults.standard.removeObject(forKey: USER)
        UserDefaults.standard.removeObject(forKey: FCM_TOKEN)
        UserDefaults.standard.removeObject(forKey: EMAIL)
        UserDefaults.standard.removeObject(forKey: SESSION_ID)
        UserDefaults.standard.removeObject(forKey: REFRESH_TOKEN)
        UserDefaults.standard.removeObject(forKey: FINDER_AVAILABLE_STATUS)
        UserDefaults.standard.removeObject(forKey: AVAILABLE_STATUS)
        UserDefaults.standard.removeObject(forKey: ACTIVE_SUBSCRIPTION)
        
        sessionUpdateListners.forEach { (key: String, value: SessionUpdateListner) in
            value(.LoggedOut)
        }
    }
}
