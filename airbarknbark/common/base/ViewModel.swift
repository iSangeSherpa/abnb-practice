//
//  ViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 14/09/2022.
//

import Foundation
import RxRelay

import RxSwift

enum NavAction{
    case push(_ type: UIViewController.Type, clearBackStack:Bool = false)
    case present(_ type: UIViewController.Type)
    case pop
    
    func createViewController()->UIViewController?{
        switch(self){
        case .push(_: let type, _: _):
            return type.init()
        case .present(type: let type):
           return type.init()
        case .pop:
            return nil
        }
    }
}


enum Alert{
    case success(String, action: (()->Void)? = nil)
    case error(String, action: (()->Void)? = nil)
}

enum AlertFor{
    case success
    case error
}

open class ViewModel{
    
    let disposeBag = DisposeBag()
    
    let dismissBy = PublishRelay<Void>()
    let loading  = BehaviorRelay<Bool>(value: false)
    let alerts = PublishRelay<Alert>()
    let error = PublishRelay<Error>()
    let navActions = PublishRelay<NavAction>()

    func alert(_ message:String, alertFor:AlertFor = .error){
        switch(alertFor){
        case .success:
            alerts.accept(.success(message))
            break;
        case .error:
            alerts.accept(.error(message))
        }
    }
    
    public required init() {
        
    }
}
