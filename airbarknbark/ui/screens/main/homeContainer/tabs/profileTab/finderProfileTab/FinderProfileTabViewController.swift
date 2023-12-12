//
//  HomeTabViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit
import SDWebImage
import RxSwift

class FinderProfileTabViewController : ViewController<FinderProfileTabView, FinderProfileTabViewModel>{
    weak var parentController: HomeContainerScreenViewController?
    override func setupView(){
        
        binding.changeUserType.isHidden = true
        
        binding.refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: {
                self.binding.refreshControl.endRefreshing()
                self.viewModel.getUserDetails()
            })
            .disposed(by: disposeBag)
        
        viewModel.isProfileComplete.bind{
            switch($0){
            case ApprovalStatus.APPROVED:
                self.binding.notVerifiedMessage.isHidden = true
            case .REVIEW_REQUIRED:
                self.binding.profileIncompleteLabel.text = .ProfileTab.profileVerificationStatus.REVIEW_REQUIRED
            case .REJECTED:
                self.binding.profileIncompleteLabel.text = .ProfileTab.profileVerificationStatus.REJECTED
            }
        }.disposed(by: disposeBag)
        
        viewModel.getPreferredCurrencies()
        
        binding.editProfileButton.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(EditProfileViewController(), animated: true)
        }
        binding.changePasswordActionItem.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
        }
        binding.yourPetsActionItem.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(YourPetsViewController(), animated: true)
        }
        binding.yourDocumentsActionItem.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(YourDocumentsViewController(), animated: true)
        }
        
        binding.notificationSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(binding.notificationSwitch.rx.value)
            .bind{
                self.viewModel.updateNotificationStatus(enabled:$0)
            }.disposed(by: disposeBag)

        viewModel.notificationEnabled.bind(to: binding.notificationSwitch.rx.isOn).disposed(by: disposeBag)
        
        binding.blockedUsersActionItem.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(BlockedUsersViewController(), animated: true)
        }
        
        binding.deleteAccountActionItem.rx.tapGesture().when(.recognized).bind{ _ in
            PopupDialogView.showPopupDialog(
                vc: self,
                title: .Dialog.deleteAccountTitle,
                body: .Dialog.deleteAccountMessage,
                buttonText: "Confirm Delete",
                buttonColor: UIColor(hexString: "#CB4040"),
                showCancel:true
            ).subscribe(onSuccess: {
                self.viewModel.deleteAccount()
            },onCompleted: {
                
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        
        binding.logoutActionItem.addOnClickListner {[unowned self] in
            if(self.parentController != nil){
                NotificationCenter.default.removeObserver(self.parentController!)
            }
            self.viewModel.logout()
        }
        viewModel.onLogoutSuccess.bind{
            self.view.window?.rootViewController =  UINavigationController( rootViewController: LoginScreenViewController())
        }.disposed(by: disposeBag)
        
        binding.changeUserType.rx.tapGesture()
            .when(.recognized).flatMap { it in
                if(SessionManager.shared.user?.minderProfile?.completionStatus == .COMPLETED){
                    return Observable.just(Void())
                }
                return  MinderProfileSetupScreenViewController().apply { [self] it in
                    it.viewModel.fromProfile = true
                    it.viewModel.forIncompleteProfile = true
                    self.present(it, animated: true)
                }.result()
            }
            .bind { [self] it in
                self.viewModel.setActiveProfileAsMinder()
            }.disposed(by: disposeBag)
        
        
        binding.privacyPolicyItem.addOnClickListner {
            Utils.openURL(url: .Register.privacyPolicyLink)
        }
        binding.termsOfUseItem.addOnClickListner {
            Utils.openURL(url: .Register.termsLink)
        }
        
        binding.currentPaymentItem.rx.tapGesture().when(.recognized).bind{ _ in
            if(self.viewModel.isEligibleForChangingPlan.value){
                self.parentController?.navigationController?.pushViewController(SubscriptionsViewController(), animated: true)
            }
        }.disposed(by: disposeBag)
        
        viewModel.activeSubscription.bind{ [weak self] sub in
            self?.binding.currentPaymentItem.plan = "Current: \(sub?.priceString ?? "")"
        }.disposed(by: disposeBag)
        
        viewModel.expiresDate.bind{[weak self] expiresDate in
            self?.binding.currentPaymentItem.expiresDateLabel.text = expiresDate
        }.disposed(by: disposeBag)
        
        initDetailObservers()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loadDetails()
    }
    func initDetailObservers(){
        viewModel.image.bind{
            self.binding.avatarImage.loadImage(src: $0, type: .User)
        }.disposed(by: disposeBag)
        
        viewModel.name.bind(to: binding.userName.rx.text).disposed(by: disposeBag)
        viewModel.location.bind(to: binding.location.rx.text).disposed(by: disposeBag)
        viewModel.phone.bind(to: binding.phoneNumber.rx.text).disposed(by: disposeBag)
        
    }
}

