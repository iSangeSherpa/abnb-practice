//
//  RealmService.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/12/2022.
//

import Foundation
import UIKit
import RealmSwift

struct RealmMigration{
    var fromVersion:Int
    var toVersion:Int
    var by : (_ migration: Migration) -> Void
}

class RealmService: AppService{
    
    let schemaVersion:UInt64 = 14
    
    func appDidStarted(application: UIApplication) {
        setupRealm()
        
        SessionManager.shared.addSessionUpdateListner(key: String(describing:RealmService.self), listner: onSessionUpdated(event:))
    }
    
    func setupRealm(){
        
        try! validateMigrations()
        
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { [self] migrationSteps, oldSchemaVersion in
                for migration in realmMigrations{
                    migration.by(migrationSteps)
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    

func onSessionUpdated(event:SessionUpdateEvent){
    
    let realm = try! Realm()
    
    switch(event){
    case .LoggedIn:
        break;
        
    case .LoggedOut:
        try! realm.write {
            realm.deleteAll()
        }
        break;
    }
}
    func validateMigrations() throws {
        var version = Int(schemaVersion)
        for migration in realmMigrations{
            if(migration.fromVersion < version){
                throw "Invalid migration from \(migration.fromVersion) to \(migration.toVersion)"
            }
            version = migration.toVersion
        }
        
        if(version>schemaVersion){
            throw "Invalid migration"
        }
    }
    
    let realmMigrations : [RealmMigration] = [
        
    ]
    
}
