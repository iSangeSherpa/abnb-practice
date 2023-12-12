//
//  NotificationViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 18/11/2022.
//

import Foundation
import RxRelay
import RxSwift

enum NavigationType{
    case MINDING_BY(id: String)
    case MINDING_FOR(id: String)
    case MINDER_REQUEST(id: String)
    case FINDER_REQUEST(id : String)
    case MINDER_BOOKING(id : String)
    case FINDER_BOOKING(id : String)
    case NEW_REVIEW
    case CONVERSATION
    case CHAT_MESSAGE(id : String)
    case PROFILE_UPDATED
}
class NotificationsViewModel : ViewModel{
    let notificationsRepository = NotificationsRepositoryImpl()
    let homeRepository = HomeRepositoryImpl()
    let notificationItems = BehaviorRelay<[Notification]>(value: [])
    let notificationClicked = PublishRelay<Notification>()
    let triggerHomeRefresh = PublishRelay<Void>()
    
    let navigateTo = PublishRelay<NavigationType>()
    
    required init() {
        super.init()
        attachNotificationFlow()
        
        notificationClicked.bind{[self] notificationModel in
            markNotificationAsSeen(notificationId:notificationModel.id)
            switch(notificationModel.type){
                
            case .SENT_MINDING_REQUEST:
                self.getMindingRequest(id: notificationModel.resourceId){
                        let mindingRequestType = $0
                        switch(mindingRequestType){
                        case MindingRequestType.ACTIVE:
                            self.navigateTo.accept(.MINDING_BY(id:notificationModel.resourceId))
                        case MindingRequestType.COMPLETED:
                            self.navigateTo.accept(.MINDING_BY(id:notificationModel.resourceId))
                        case MindingRequestType.BOOKING:
                            self.navigateTo.accept(.FINDER_BOOKING(id:notificationModel.resourceId))
                        case MindingRequestType.REQUEST:
                            self.navigateTo.accept(.FINDER_REQUEST(id:notificationModel.resourceId))
                        }
                    }
                
            case .RECEIVED_MINDING_REQUEST:
                self.getMindingRequest(id: notificationModel.resourceId){
                        let mindingRequestType = $0
                        switch(mindingRequestType){
                        case MindingRequestType.COMPLETED:
                            self.navigateTo.accept(.MINDING_FOR(id:notificationModel.resourceId))
                        case MindingRequestType.ACTIVE:
                            self.navigateTo.accept(.MINDING_FOR(id:notificationModel.resourceId))
                        case MindingRequestType.BOOKING:
                            self.navigateTo.accept(.MINDER_BOOKING(id:notificationModel.resourceId))
                        case MindingRequestType.REQUEST:
                            self.navigateTo.accept(.MINDER_REQUEST(id:notificationModel.resourceId))
                        }
                    }
                
            case .NEW_REVIEW:
                self.navigateTo.accept(.NEW_REVIEW)
            case .NEW_MESSAGE:
                navigateTo.accept(.CHAT_MESSAGE(id: notificationModel.resourceId))
            case .NEW_CONVERSATION:
                navigateTo.accept(.CONVERSATION)
            case .PROFILE_UPDATED:
                navigateTo.accept(.PROFILE_UPDATED)
            default:
                break
            }
        }.disposed(by: disposeBag)
        refreshNotifications()
    }
    
    func attachNotificationFlow(){
        notificationsRepository.getAllNotificationsFlow()
            .bind(onNext:{
                self.notificationItems.accept($0)
            }
            ).disposed(by: disposeBag)
        
    }
    
    func getMindingRequest(id: String, onSuccess:((MindingRequestType)->Void)? = nil){
         homeRepository.getSentMindingRequestDetails(requestId: id)
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe( onSuccess: {
               onSuccess?($0.getMindingRequestType())
            } , onFailure: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func refreshNotifications(){
        notificationsRepository.refreshNotifications()
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(onError: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func markNotificationAsSeen(notificationId:String){
        notificationsRepository.markNotificationAsSeen(notificationId: notificationId)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(onError: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func deleteNotification(notificationId:String){
        notificationsRepository.deleteNotification(notificationId: notificationId)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            )
            .subscribe(onError: self.error.accept(_:))
            .disposed(by: disposeBag)
    }
    
    func markAllAsSeen(){
        Observable.concat(
            notificationItems.value.filter{!$0.isSeen}.map{
                notificationsRepository.markNotificationAsSeen(notificationId: $0.id).asObservable()
            }
        ).do(
            onSubscribe: { [weak self] in
                self?.loading.accept(true)
            },
            onDispose: { [weak self] in
                self?.loading.accept(false)
            }
        )
        .subscribe(onError : self.error.accept(_:))
        .disposed(by: disposeBag)
        
    }
}
