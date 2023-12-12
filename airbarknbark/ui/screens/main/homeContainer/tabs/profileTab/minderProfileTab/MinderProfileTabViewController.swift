//
//  MinderProfileTabViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class MinderProfileTabViewController : ViewController <MinderProfileTabView, MinderProfileTabViewModel>{
   
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
        binding.pastWorksActionItem.addOnClickListner { [unowned self] in
            PastWorksViewController().apply {[unowned self]  it in
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }
        }
        binding.yourReviewsActionItem.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(YourReviewsViewController(), animated: true)
        }
        
        binding.blockedUsersActionItem.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController(BlockedUsersViewController(), animated: true)
        }
        
        binding.deleteAccountActionItem.rx.tapGesture().when(.recognized).bind{[unowned self] _ in
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
        viewModel.onLogoutSuccess.bind{[unowned self] in
            self.view.window?.rootViewController =  UINavigationController( rootViewController: LoginScreenViewController())
        }.disposed(by: disposeBag)
     
        binding.changeUserType.addOnClickListner { [unowned self] in
            viewModel.setActiveProfileAsFinder()
        }
        
        binding.privacyPolicyItem.addOnClickListner {
            Utils.openURL(url: .Register.privacyPolicyLink)
        }
        binding.termsOfUseItem.addOnClickListner {
            Utils.openURL(url: .Register.termsLink)
        }
        
        binding.notificationSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(binding.notificationSwitch.rx.value)
            .bind{[unowned self] in
                self.viewModel.updateNotificationStatus(enabled:$0)
            }.disposed(by: disposeBag)

        viewModel.notificationEnabled.bind(to: binding.notificationSwitch.rx.isOn).disposed(by: disposeBag)
        
        binding.currentPaymentItem.rx.tapGesture().when(.recognized).bind{[unowned self] _ in
            if(true){
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
        viewModel.image.bind{[unowned self] in
            self.binding.avatarImage.loadImage(src: $0, type: .User)
        }.disposed(by: disposeBag)
        
        viewModel.name.bind(to: binding.userName.rx.text).disposed(by: disposeBag)
        viewModel.location.bind(to: binding.location.rx.text).disposed(by: disposeBag)
        viewModel.phone.bind(to: binding.phoneNumber.rx.text).disposed(by: disposeBag)
        
    }
    
}
