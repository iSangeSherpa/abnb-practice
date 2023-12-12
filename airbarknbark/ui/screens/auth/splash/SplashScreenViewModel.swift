//
//  SplashScreenViewModel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/12/2022.
//

import Foundation
import RxSwift
import RxRelay


class SplashScreenViewModel : ViewModel{
    let delayMS = 1000
    private let sessionManager  = SessionManager.shared
    private let userRepository = UserRepositoryImpl()
    let requireForceUpdate = PublishRelay<AppVersion>()
    
    required init() {
        super.init()
    }

    func checkAppVersionAndSesion(){
        userRepository.getAppVersion()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).subscribe(
                onSuccess: { serverVersion in
                    guard let appVersion = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String) else{
                        self.checkSession()
                        return
                    }
                    
                    guard let latestVersion = Int(serverVersion.ios ?? "0") , (serverVersion.forceUpdate ?? false) else {
                        self.checkSession()
                        return
                    }
                    if(appVersion < latestVersion){
                        self.requireForceUpdate.accept(serverVersion)
                    }
                    else{
                        self.checkSession()
                    }
                },
                onFailure: { _ in
                    self.checkSession()
                }
            ).disposed(by: disposeBag)
    }
     
    func checkSession(){
        if(sessionManager.isLoggedIn){
            if let user = sessionManager.user{
                Single.just(nextDestinationForUser(user: user))
                    .delay(.milliseconds(delayMS), scheduler: MainScheduler.asyncInstance)
                    .subscribe(onSuccess: navActions.accept(_:))
                    .disposed(by: disposeBag)
            }else{
                fetchUserDetails()
            }
        }else{
            Single.just(NavAction.push(LandingScreenViewController.self, clearBackStack: true))
                .delay(.milliseconds(delayMS), scheduler: MainScheduler.asyncInstance)
                .subscribe(onSuccess: navActions.accept(_:))
                .disposed(by: disposeBag)
        }
    }
    
    func fetchUserDetails(){
        userRepository.getUserDetails()
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    self?.loading.accept(true)
                },
                onDispose: { [weak self] in
                    self?.loading.accept(false)
                }
            ).do(onSuccess: { [weak self] it in
                self?.sessionManager.user = it
            }).map(nextDestinationForUser)
            .subscribe(
                onSuccess: navActions.accept(_:),
                onFailure: error.accept(_:)
            ).disposed(by: disposeBag)
    }
    
    func nextDestinationForUser(user:UserDetails) -> NavAction {
        return .push(user.hasProfileToComplete || SessionManager.shared.userType == nil ? SetupProfileScreenViewController.self : HomeContainerScreenViewController.self, clearBackStack: true)
    }
}
