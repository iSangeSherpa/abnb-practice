//
//  AppDelegate.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 06/09/2022.
//

import UIKit
import IQKeyboardManagerSwift
import AlamofireNetworkActivityLogger
import SVProgressHUD
import FirebaseCore
import FirebaseMessaging
import SwiftyStoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let deletageServices: [AppService] = [
        RealmService(),
        PushNotificationService(),
        KeyboardManagerService(),
        ProgressHUDService(),
        SocketServices(),
        SdWebImageService()
    ]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
    #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    #endif
        
        FirebaseApp.configure()
        
        
        deletageServices.forEach {
            $0.appDidStarted(application: application)
        }
        
    
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    @unknown default:
                        break
                    }
                    print("xxx",purchase.transaction.transactionState)
                }
            }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
        
        LocationService.shared.getLocation()
      
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        let type = userInfo["type"] as? String ?? ""
//
//        if(type == "NEW_MESSAGE"){
//            SessionManager.shared.chatBadgeCount = (SessionManager.shared.chatBadgeCount ?? 0) + 1
//        }else{
//            SessionManager.shared.notificationBadgeCount = (SessionManager.shared.notificationBadgeCount ?? 0) + 1
//        }
//
//        UIApplication.shared.applicationIconBadgeNumber = (SessionManager.shared.notificationBadgeCount ?? 0) + (SessionManager.shared.chatBadgeCount ?? 0)
//
        completionHandler(UIBackgroundFetchResult.newData)
        
        
     }
    
}
