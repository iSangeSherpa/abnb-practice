//
//  NotificationRepository.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 14/12/2022.
//

import Foundation
import RxSwift
import RealmSwift

protocol  NotificationsRepository{
    func getAllNotificationsFlow() -> Observable<[Notification]>
    func refreshNotifications() -> Completable
    func markNotificationAsSeen(notificationId : String) -> Completable
    func deleteNotification(notificationId : String) -> Completable
}

class NotificationsRepositoryImpl : NotificationsRepository{
    
    private let realm = try! Realm()
    
    func getAllNotificationsFlow() -> Observable<[Notification]> {
        let notificationsFilter = realm.objects(Notification.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .distinct(by: ["id"])
        
        return Observable.array(from: notificationsFilter)
    }
    
    func refreshNotifications() -> Completable {
        return ApiService.getAllNotification(userId: SessionManager.shared.userId!)
            .do(onSuccess: { [self] result in
                
                let notifications =  result.data.map { it in
                    it.toDomain()
                }
                
                try! realm.write { [self] in
                    self.realm.add(notifications, update: .modified)
                }
            }).asCompletable()
                }
    
    func markNotificationAsSeen(notificationId : String) -> Completable{
        return ApiService.markNotificationAsSeen(userId: SessionManager.shared.userId!, notificationId: notificationId)
            .map{
                $0.data.toDomain()
            }
            .do(onSuccess: { [self] notification in
                try! self.realm.write {
                    let notificationObject = realm.object(ofType: Notification.self, forPrimaryKey: notification.id)
                    notificationObject?.isSeen = notification.isSeen
                }
            })
            .asCompletable()
    }
    
    func deleteNotification(notificationId : String) -> Completable{
        return ApiService.deleteNotification(userId: SessionManager.shared.userId!, notificationId: notificationId)
            .map{
                $0.data.toDomain()
            }
            .do(onSuccess: { [self] notification in
                try! self.realm.write {
                    let notificationObject = realm.object(ofType: Notification.self, forPrimaryKey: notification.id)
                    if(notificationObject != nil){
                        self.realm.delete(notificationObject!)
                    }
                }
            })
            .asCompletable()
    }
}
