//
//  HomeTabViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseMessaging

class FinderProfileTabViewModel : ViewModel{
    let userRepository = UserRepositoryImpl()
    var currenciesList = BehaviorRelay<[Currency]>(value: [])
    let userRepoImpl = UserRepositoryImpl()
    let onLogoutSuccess = PublishRelay<Void>()
    
    let notificationEnabled = BehaviorRelay<Bool>(value: true)
    
    let isProfileComplete = BehaviorRelay<ApprovalStatus>(value: .REVIEW_REQUIRED)
    
    let image = BehaviorRelay<String>(value: "")
    let name = BehaviorRelay<String>(value: "")
    let location = BehaviorRelay<String>(value: "")
    let phone = BehaviorRelay<String>(value: "")
    let isEligibleForChangingPlan = BehaviorRelay<Bool>(value: false)
   
    let activeSubscription = SessionManager.shared.activeSubscriptionFlow
    let expiresDate = BehaviorRelay<String>(value: "")
    
    func getPreferredCurrencies() {
        userRepoImpl.getAllCurrency()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { [weak self] currencyList in
                    self?.currenciesList.accept(currencyList)
                },
                onFailure: { [weak self] err in
                    self?.error.accept(err)
                }).disposed(by: disposeBag)
                
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
        self.isProfileComplete.accept(SessionManager.shared.user?.finderProfile?.approvalStatus ?? .REVIEW_REQUIRED)
        self.image.accept(SessionManager.shared.user?.image ?? "-")
        self.name.accept(SessionManager.shared.user?.fullName ?? "-")
        self.location.accept(SessionManager.shared.user?.address?.name ?? "-")
        self.phone.accept(SessionManager.shared.user?.phoneNumber ?? "-")
        self.expiresDate.accept(SessionManager.shared.user?.subscription?.paymentType == .FREE ? "(Expires on  \(SessionManager.shared.user?.subscription?.expiresDate.asDateTime().asPreetyDateString() ?? "")" : "")
        
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
    
    func setActiveProfileAsMinder(){
        
        self.userRepository.updateUserDetails(
            activeProfile: ActiveProfile.MINDER.rawValue)
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
