//
//  SubscriptionPaymentDialogViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/07/2023.
//

import Foundation
import RxSwift
import SwiftyStoreKit
import TPInAppReceipt
import StoreKit


class SubscriptionPaymentDialogViewController : ViewController<SubscriptionPaymentDialogView,SubscriptionPaymentDialogViewModel>{
    
    override func setupView() {
        super.setupView()
        
        binding.proceedToPaymentBtn.rx.tapGesture().when(.recognized).bind{ _ in
            self.viewModel.proceedPayment()
        }.disposed(by: disposeBag)
        
        Observable<SubscriptionType?>.merge(
            binding.monthlyPaymentButton.onButtonPressed.map{it in it ? SubscriptionType.MONTHLY : nil},
            binding.halfYearlyPaymentButton.onButtonPressed.map{it in it ? SubscriptionType.HALF_YEARLY : nil},
            binding.yearlyPaymentButton.onButtonPressed.map{it in it ? SubscriptionType.YEARLY : nil}
        ).bind(to: viewModel.selectedSubscriptionType).disposed(by: disposeBag)
        
        viewModel.selectedSubscriptionType.bind{
            self.binding.monthlyPaymentButton.isSelected = SubscriptionType.MONTHLY == $0
            self.binding.halfYearlyPaymentButton.isSelected = SubscriptionType.HALF_YEARLY == $0
            self.binding.yearlyPaymentButton.isSelected = SubscriptionType.YEARLY == $0
        }.disposed(by: disposeBag)
        
        viewModel.prouctDetails.bind{[weak self] productList in
            guard let productDetails = productList else {return}
            for product in productDetails{
                switch(product.type){
                case SubscriptionType.MONTHLY:
                    self?.binding.monthlyPaymentButton.price = product.priceString
                    break
                    
                case SubscriptionType.HALF_YEARLY:
                    self?.binding.halfYearlyPaymentButton.price = product.priceString
                    break
                    
                case SubscriptionType.YEARLY:
                    self?.binding.yearlyPaymentButton.price = product.priceString
                    break
                }
            }
            
        }.disposed(by: disposeBag)
        
        binding.redeemCouponLabel.rx.tapGesture().when(.recognized).bind{ _ in
            let paymentQueue = SKPaymentQueue.default()
            paymentQueue.presentCodeRedemptionSheet()
        }.disposed(by: disposeBag)
        
        binding.restorePurchaseLabel.rx.tapGesture().when(.recognized).bind{[weak self] _ in
            self?.viewModel.restorePurchase()
        }.disposed(by: disposeBag)
        
        binding.termsOfUse.rx.tapGesture().when(.recognized).bind{ _ in
            Utils.openURL(url: .Register.termsLink)
        }.disposed(by: disposeBag)
        
        binding.privacyPolicy.rx.tapGesture().when(.recognized).bind{_ in
            Utils.openURL(url: .Register.privacyPolicyLink)
        }.disposed(by: disposeBag)
        
    
        binding.moreIcon.rx.tapGesture()
            .when(.recognized)
            .flatMap { [self] it in
                showMoreMenuDialog()
            }.bind { [self] menuIndex in
                switch(menuIndex){
                case SubscriptionMoreMenuDialog.DELETE_ACCOUNT:
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
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
                    }
                case SubscriptionMoreMenuDialog.LOGOUT:
                    viewModel.logout()
                default: break
                }
            }.disposed(by: disposeBag)
        
        viewModel.onLogoutSuccess.bind{
            self.view.window?.rootViewController =  UINavigationController( rootViewController: LoginScreenViewController())
        }.disposed(by: disposeBag)
    }
    
    
    func showMoreMenuDialog() -> Maybe<Int>{
        return .create{ [self] maybe in
            let viewController = DialogViewController<SubscriptionMoreMenuDialog,ViewModel>().setupBy { dialog in
                dialog.binding.crossButton.addOnClickListner {
                    maybe(.completed)
                }
                
                dialog.binding.optionDeleteAccount.addOnClickListner{
                    maybe(.success(SubscriptionMoreMenuDialog.DELETE_ACCOUNT))
                }
                
                dialog.binding.optionLogout.addOnClickListner{
                    maybe(.success(SubscriptionMoreMenuDialog.LOGOUT))
                }

            }
            present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }
    }
}

extension SubscriptionPaymentDialogViewController {
    func result() -> Observable<SubscriptionType>{
        return self.viewModel.onPaymentSuccess.asObservable()
    }
}
