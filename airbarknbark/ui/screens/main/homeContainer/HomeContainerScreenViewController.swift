//
//  HomeContainerScreenViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit
import StoreKit
import RxSwift

struct NavItem{
    var title:String
    var icon:String
    var vc: UIViewController
}

class HomeContainerScreenViewController : ViewController<HomeContainerScreenView, HomeContainerScreenViewModel>{
    
    
    func getNavItems(userType:ActiveProfile?)->[NavItem]{
        guard let activeProfile = userType else {
            return []
        }
        
        switch(activeProfile){
        case .BOTH:
            return [
                .init(title: .HomeContainer.Map, icon: "ic_tab_map", vc: FinderMapTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.home , icon: "ic_tab_home", vc: BothHomeTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.chat, icon: "ic_tab_chat", vc: FinderChatTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.profile, icon: "ic_tab_profile", vc: MinderProfileTabViewController().apply({ it in
                    it.parentController = self
                })),
            ]
        case .MINDER:
            return [
                .init(title: .HomeContainer.Map, icon: "ic_tab_map", vc: MinderMapTabViewController()),
                .init(title: .HomeContainer.home , icon: "ic_tab_home", vc: MinderHomeTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.chat, icon: "ic_tab_chat", vc: FinderChatTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.profile, icon: "ic_tab_profile", vc: MinderProfileTabViewController().apply({ it in
                    it.parentController = self
                })),
            ]
        case .FINDER:
            return [
                .init(title: .HomeContainer.Map, icon: "ic_tab_map", vc: FinderMapTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.home , icon: "ic_tab_home", vc: FinderHomeTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.chat, icon: "ic_tab_chat", vc: FinderChatTabViewController().apply({ it in
                    it.parentController = self
                })),
                .init(title: .HomeContainer.profile, icon: "ic_tab_profile", vc: FinderProfileTabViewController().apply({ it in
                    it.parentController = self
                })),
            ]
        }
    }
    
    @objc func onViewDidReAppear(){
        LocationService.shared.getLocation()
     
        LocationService.shared.locationServicesEnabled(){[unowned self] enabled in
            if(!enabled){
                if(!self.viewModel.isShowingEnableLocationDialog){
                    self.viewModel.isShowingEnableLocationDialog = true
                    EnableLocationViewController().apply { it in
                        self.present(it, animated: true)
                    }
                }
            }
        }
    }
    

    @objc func didEnterBackground(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onViewDidReAppear), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func setupView() {
        NotificationCenter.default.removeObserver(self)
        viewModel.userType.bind { [weak self] it in
            self?.setupBottomNavBar(navItems: self?.getNavItems(userType: it) ?? [],chatBadgeCount : SessionManager.shared.chatBadgeCount ?? 0)
        }.disposed(by: disposeBag)
    
        
        viewModel.chatBadgeCount.bind{ [weak self] it in
            self?.getNavItems().map{
                if($0.label.text == .HomeContainer.chat){
                    $0.addBadge(badgeCount: SessionManager.shared.chatBadgeCount ?? 8)
                }
            }
            
//            self?.setupBottomNavBar(navItems: ,chatBadgeCount : it ?? 0)
            
        }.disposed(by: disposeBag)
        
        UIApplication.shared.applicationIconBadgeNumber = (SessionManager.shared.chatBadgeCount ?? 0) + (SessionManager.shared.notificationBadgeCount ?? 0)
        
//        viewModel.notificationBadgeCount.bind{ [weak self] it in
//            UIApplication.shared.applicationIconBadgeNumber = (it ?? 0) + (SessionManager.shared.chatBadgeCount ?? 0)
//        }.disposed(by: disposeBag)
        
        
        #if !DEBUG
     
        viewModel.showPaymentDialog.flatMap{[weak self] showPaymentDialog in
            if(showPaymentDialog){
                return SubscriptionPaymentDialogViewController().apply({ it in
                    it.modalPresentationStyle = .fullScreen
                    self?.present(it, animated: true)
                }).result()
            }else{
                return Observable.empty()
            }
        }.bind{paymentSuccess in
            if(paymentSuccess != nil){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.dismiss(animated: true)
                }
            }
        }.disposed(by: disposeBag)
        
        #endif
        
        viewModel.alreadySubscribedInOtherAccount.bind{ email in
            if(SessionManager.shared.isLoggedIn){
                self.viewModel.showAlertDialog(title: "Subscription", message: .AppSubscription.alreadySubscribedInOtherAccount + "\(email)", buttonText: "Logout"){
                    NotificationCenter.default.removeObserver(self)
                    self.viewModel.logout()
                    
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.onLogoutSuccess.bind{
            self.view.window?.rootViewController =  UINavigationController( rootViewController: LoginScreenViewController())
        }.disposed(by: disposeBag)
     
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIScene.didEnterBackgroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
        
        onViewDidReAppear()
    }
   
    
    var navControllers : [(UINavigationController,BottomTabbarItem)]!
    
    func setupBottomNavBar(navItems:[NavItem],chatBadgeCount:Int){
        
        binding.bottomNavBar.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        binding.contentView.subviews.forEach { it in
            it.removeFromSuperview()
        }
        
        self.navControllers = navItems.map{ navItem in
            (UINavigationController(rootViewController: navItem.vc),
             binding.newBottomNavItem(icon: navItem.icon, label: navItem.title))
        }
        
        for (index, (_, navBarItem)) in self.navControllers.enumerated(){
            navBarItem.addOnClickListner {[unowned self] in
                self.setSelctedItem(selectedIndex: index)
            }
        }
        binding.bringSubviewToFront(binding.bottomNavBar)
        
        setSelctedItem(selectedIndex: 0)
    }
    
    func setSelctedItem(selectedIndex:Int){
        for (index, (vc, navBarItem)) in self.navControllers.enumerated(){
            navBarItem.isSelected  = index == selectedIndex
            if(index == selectedIndex){
                binding.contentView.addSubview(vc.view)
                vc.view.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
                vc.didMove(toParent: self)
            }else{
                vc.view.removeFromSuperview()
            }
        }
    }
    
    func getNavItems() -> [BottomTabbarItem]{
        return self.navControllers.map{
           (_, navBarItem) in
            navBarItem
        }
    }
    
}
