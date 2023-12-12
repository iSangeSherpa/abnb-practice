//
//  FirebaseMessagingService.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/12/2022.
//

import Foundation
import UserNotifications
import FirebaseMessaging
import FirebaseCore

class PushNotificationService: AppService {
 
    func appDidStarted(application: UIApplication) {
       
        setupNotification(application: application)
        
        handleFcmToken()
        
        SessionManager.shared.addSessionUpdateListner(key: String(describing:PushNotificationService.self), listner: onSessionUpdated(event:))
    }
    
    func handleFcmToken(){
        if let token = Messaging.messaging().fcmToken{
            SessionManager.shared.lastFcmToken = token
            print("FCM TOKEN \(token)")
           let _ = UserRepositoryImpl().uploadFcmTokenIfNecessary()
                .do(onCompleted: {
                    SessionManager.shared.lastFcmToken = token
                })
                .catch{ it in
                    .empty()
                }.subscribe()
        }
    
        
        
    }
    
    func onSessionUpdated(event:SessionUpdateEvent){
        switch(event){
        case .LoggedIn:
            handleFcmToken()
            break;
            
        case .LoggedOut:
            Messaging.messaging().deleteToken(completion: { _ in })
            break;
        }
    }
    
    
    private func setupNotification(application: UIApplication){
        if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().delegate = application
             let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
             UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
//             Messaging.messaging().delegate = application
             application.registerForRemoteNotifications()
         } else {
            
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
         }
//         FirebaseApp.configure()
    }
    
    static func handleNotificationTap(_ response: UNNotificationResponse) {
       
    }
}

extension UIApplication: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
   public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        PushNotificationService.handleNotificationTap(response)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
   public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
}
