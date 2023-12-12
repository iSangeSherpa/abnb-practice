//
//  HomeContainerScreenViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxSwift
import RxRelay
import SwiftyStoreKit
import FirebaseMessaging

class HomeContainerScreenViewModel : ViewModel {
    let userType: Observable<ActiveProfile?> = SessionManager.shared.userTypeFlow
    let chatBadgeCount: Observable<Int?> = SessionManager.shared.chatBadgeCountFlow
    let notificationBadgeCount: Observable<Int?> = SessionManager.shared.notificationBadgeCountFlow
    let showUpdateApp = PublishRelay<Void>()
    let showPaymentDialog = PublishRelay<Bool>()
    let alreadySubscribedInOtherAccount = PublishRelay<String>()
    let onLogoutSuccess = PublishRelay<Void>()
    var isShowingEnableLocationDialog = false
    
    private let userRepository = UserRepositoryImpl()
    private let subscriptionRepository = SubscriptionRepositoryImpl()

    required init() {
        super.init()
        fetchUserDetails()
        SubscriptionHelper.shared.loadPrices{_ in }
    }
    
    
    func fetchUserDetails(){
        userRepository.getUserDetails()
           .do(onSuccess: { it in
               SessionManager.shared.user = it
            })
            .subscribe(
                onSuccess: { it in
                    #if !DEBUG
                    self.showUpdateApp.accept(Void())
                    self.checkSubscription()
                    #endif
                },
                onFailure: error.accept(_:)
            ).disposed(by: disposeBag)
    }
    
    func checkSubscription(){
        subscriptionRepository.checkActiveSubscription()
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(
                onSuccess: { subscriptionDetails in
                    self.checkForAppReceiptAndProceed(subscriptionDetails: subscriptionDetails)
                },
                onFailure: error.accept(_:)
            ).disposed(by: disposeBag)
    }
    
    func checkForAppReceiptAndProceed(subscriptionDetails : CheckActiveSubscriptionResponse){
        if(subscriptionDetails.hasActiveSubscription){
            self.showPaymentDialog.accept(false)
        }else{
            self.loading.accept(true)
            SubscriptionHelper.shared.getReceipt{ appReceipt in
                self.loading.accept(false)
                if(appReceipt == nil){
                    self.showPaymentDialog.accept(true)
                    return
                }
                self.subscriptionRepository.checkForInitialSubscription(receipt: appReceipt?.base64 ?? "").do(
                    onSubscribe: { [weak self] in
                        self?.loading.accept(true)
                    },
                    onDispose: { [weak self] in
                        self?.loading.accept(false)
                    }
                )
                .subscribe(
                    onSuccess: { receiptSubscribedBy in
                        if(receiptSubscribedBy.isEmpty){
                            //MAKR: RECEIPT IS NOT ASSOCIATED WITH ANY OTHER USER so send it to server
                            self.sendAppReceiptToServer(receipt: appReceipt?.base64 ?? "")
                            return
                        }
                        if(receiptSubscribedBy == SessionManager.shared.email){
                            //MARK: App receipt is associated with current user
                            self.showPaymentDialog.accept(true)
                        }else{
                            //MARK: App receipt is associated with other user so cannot be changed from current user session, should logout
                            self.showPaymentDialog.accept(false)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.alreadySubscribedInOtherAccount.accept(receiptSubscribedBy)
                            }
                            
                        }
                    },
                    onFailure: { error in
                        switch((error as! Failure)){
                        case .ServerError(_,let status):
                            if(status == "airbark_90001"){
                                self.showPaymentDialog.accept(true)
                            }
                        case .UnknownError(_):
                            break
                        case .UnAuthenticatedError:
                            break
                        }
                        
                    }
                ).disposed(by: self.disposeBag)
            }
        }
    }
    
    func sendAppReceiptToServer(receipt : String){
        self.subscriptionRepository.sendReceiptToServer(receipt: receipt)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(
                onSuccess: { subscriptionDetails in
                    self.checkSubscription()
                },
                onFailure: { error in
                    self.showAlertDialog(title: "Error", message: error.localizedDescription, buttonText: "OK"){
                        self.checkSubscription()
                    }
                }
            ).disposed(by: self.disposeBag)
    }
    
    
    func showAlertDialog(title : String, message : String, buttonText : String, action: (()->())? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: { (_) in
            action?()
        }))
        var rootViewController = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            rootViewController?.present(alert, animated: true)
        }
    }
    
    func logout(){
        userRepository.logout()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { [weak self] it in
                    Messaging.messaging().deleteFCMToken(forSenderID: Config.FCM_SENDER_ID, completion: { _ in})
                    SessionManager.shared.clearSession()
                    self?.onLogoutSuccess.accept(Void())
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
}
