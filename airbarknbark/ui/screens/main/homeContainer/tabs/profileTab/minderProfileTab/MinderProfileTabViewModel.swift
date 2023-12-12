//
//  MinderProfileTabViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import RxRelay
import RxSwift
import FirebaseMessaging

class MinderProfileTabViewModel:ViewModel{
    let onLogoutSuccess = PublishRelay<Void>()
    
    let userRepository = UserRepositoryImpl()
    
    let image = BehaviorRelay<String>(value: "")
    let name = BehaviorRelay<String>(value: "")
    let location = BehaviorRelay<String>(value: "")
    let phone = BehaviorRelay<String>(value: "")
    let notificationEnabled = BehaviorRelay<Bool>(value: true)
    
    let isProfileComplete = BehaviorRelay<ApprovalStatus>(value: .REVIEW_REQUIRED)
    
    let activeSubscription = SessionManager.shared.activeSubscriptionFlow
    
    let isEligibleForChangingPlan = BehaviorRelay<Bool>(value: false)
    let expiresDate = BehaviorRelay<String>(value: "")
    
    required init() {
        super.init()
        
        self.loadDetails()
    }
    
    func updateNotificationStatus(enabled:Bool){
        SessionManager.shared.notificationEnabled = enabled
        if(enabled){
            UIApplication.shared.registerForRemoteNotifications()
        }else{
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func loadDetails(){
        self.notificationEnabled.accept(SessionManager.shared.notificationEnabled ?? true)
        self.isProfileComplete.accept(SessionManager.shared.user?.minderProfile?.approvalStatus ?? .REVIEW_REQUIRED)
        self.image.accept(SessionManager.shared.user?.image ?? "-")
        self.name.accept(SessionManager.shared.user?.fullName ?? "-")
        self.location.accept(SessionManager.shared.user?.address?.name ?? "-")
        self.phone.accept(SessionManager.shared.user?.phoneNumber ?? "-")
        self.expiresDate.accept(SessionManager.shared.user?.subscription?.paymentType == .FREE ? "(Expires on \(SessionManager.shared.user?.subscription?.expiresDate.asDateTime().asPreetyDateString() ?? "")" : "")
        
        guard let subscription = SessionManager.shared.user?.subscription else{
            self.isEligibleForChangingPlan.accept(false)
            return
        }
        self.isEligibleForChangingPlan.accept(
            (subscription.deviceType == DeviceType.IOS) || (subscription.paymentType == PaymentType.FREE)
        )
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
    
    func getUserDetails(){
        userRepository.getUserDetails()
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
                    SessionManager.shared.userType = it.activeProfile
                    SessionManager.shared.user = it
                    SessionManager.shared.setActiveSubscription(productdId: it.subscription?.productId ?? "")
                    
                    self?.loadDetails()
                },
                onFailure : self.error.accept
            ).disposed(by: disposeBag)
    }
    
    func setActiveProfileAsFinder(){
        self.userRepository.updateUserDetails(
            activeProfile: ActiveProfile.FINDER.rawValue)
        .observe(on: MainScheduler.instance)
        .do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            })
            .subscribe(onSuccess: {
                SessionManager.shared.user = $0
                SessionManager.shared.userType = $0.activeProfile
                
            },onFailure:self.error.accept).disposed(by: disposeBag)
    }
    
    func deleteAccount(){
        userRepository.deleteAccount()
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
