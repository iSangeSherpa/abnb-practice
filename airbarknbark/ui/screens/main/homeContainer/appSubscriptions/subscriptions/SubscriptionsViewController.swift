//
//  SubscriptionsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/07/2023.
//

import Foundation
import RxSwift
import StoreKit
import SVProgressHUD
import SwiftyStoreKit

class SubscriptionsViewController : ViewController<SubscriptionsView,SubscriptionsViewModel>{
    
    override func setupView() {
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
        
        viewModel.subscriptionProfuctList.bind{[weak self] productList in
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
        
        viewModel.activeSubscription.bind{[weak self] activeSub in
            self?.binding.monthlyPaymentButton.isSubscribed = activeSub?.type == .MONTHLY
            self?.binding.halfYearlyPaymentButton.isSubscribed = activeSub?.type == .HALF_YEARLY
            self?.binding.yearlyPaymentButton.isSubscribed = activeSub?.type == .YEARLY
            
            self?.binding.monthlyPaymentButton.setSelected(isSelected: activeSub?.type == .MONTHLY)
            self?.binding.halfYearlyPaymentButton.setSelected(isSelected: activeSub?.type == .HALF_YEARLY)
            self?.binding.yearlyPaymentButton.setSelected(isSelected: activeSub?.type == .YEARLY)
            
            self?.viewModel.selectedSubscriptionType.accept(activeSub?.type)
            
        }.disposed(by: disposeBag)
         
        viewModel.selectedSubscriptionType.bind{ selectedSub in
            if(selectedSub == nil){
                self.binding.proceedToPaymentBtn.alpha = 0.7
                self.binding.proceedToPaymentBtn.isUserInteractionEnabled = false
                return
            }
            
            if(SessionManager.shared.activeSubscription?.type != selectedSub){
                self.binding.proceedToPaymentBtn.alpha = 1
                self.binding.proceedToPaymentBtn.isUserInteractionEnabled = true
            }else{
                self.binding.proceedToPaymentBtn.alpha = 0.7
                self.binding.proceedToPaymentBtn.isUserInteractionEnabled = false
            }
        }.disposed(by: disposeBag)
        
        binding.redeemCouponLabel.rx.tapGesture().when(.recognized).bind{ _ in
            let paymentQueue = SKPaymentQueue.default()
            paymentQueue.presentCodeRedemptionSheet()
        }.disposed(by: disposeBag)
        
        binding.restorePurchaseLabel.rx.tapGesture().when(.recognized).bind{[weak self] _ in
            self?.viewModel.restorePurchase()
        }.disposed(by: disposeBag)
        
        binding.termsOfUse.addOnClickListner {
            Utils.openURL(url: .Register.termsLink)
        }
        
        binding.privacyPolicy.rx.tapGesture().when(.recognized).bind{_ in
            Utils.openURL(url: .Register.privacyPolicyLink)
        }.disposed(by: disposeBag)
        
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
    }
    
}
