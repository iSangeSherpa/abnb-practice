//
//  SubscriptionsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 20/07/2023.
//

import Foundation
import UIKit

class SubscriptionsView : BaseUIView{
    
    
    let backButton = BackButton()
    
    
    let titleText = TitleH1Bold(label: .AppSubscription.paymentPlan).apply {
        $0.textAlignment  = .left
    }
    
    
    let monthlyPaymentButton =  SubscriptionPaymentButton(plan: "Monthly, Auto-renewable", price: "$XX.XX / Month", isSelected: false, isSubscribed: false)
    let halfYearlyPaymentButton = SubscriptionPaymentButton(plan: "Bi-annually, Auto-renewable", price: "$XX.XX / 6 Month", isSelected: false, isSubscribed: false)
    let yearlyPaymentButton = SubscriptionPaymentButton(plan: "Annually, Auto-renewable", price: "$XX.XX / Year", isSelected: false, isSubscribed: false)
    
    lazy var subscriptionPlans = stack(
        monthlyPaymentButton,
        halfYearlyPaymentButton,
        yearlyPaymentButton,
        spacing: 10
    ).apply { it in
        
    }
    
    lazy var proceedToPaymentBtn = PrimaryButton(label: .AppSubscription.proceedToPayment).apply { it in
        it.contentHorizontalAlignment = .leading
        it.configuration!.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 0.0)
        it.setTitleColor(.white, for: .normal)
    }
    
    lazy var proceedButtonWithIcon = proceedToPaymentBtn.wrapInUIView { container, child in
        let arrowImageView = UIImageView(image: UIImage(named: "ic_back_black")?.withTintColor(.white)).withHeight(20).withWidth(40)
        container.addSubViews(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.transform = child.transform.rotated(by: CGFloat(Double.pi))
        child.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    let redeemCouponLabel = Caption(label: .AppSubscription.redeem).apply { it in
        it.isHidden = true
    }
    let restorePurchaseLabel = Caption(label: .AppSubscription.restorePurchase,font: .poppinsSemibold(fontSize: 14))
    let termsAndConditionLabel = Caption(label: .AppSubscription.termsAndCondition)
    
    let privacyPolicy = Caption(label: .AppSubscription.privacyPolicy).apply { it in
        let attributedString = NSAttributedString(
            string: .AppSubscription.privacyPolicy,
            attributes: [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        )
        it.attributedText = attributedString
        it.isUserInteractionEnabled = true
        it.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_4.cgFloat
    }
    let termsOfUse = Caption(label: .AppSubscription.termsOfUse).apply { it in
        let attributedString = NSAttributedString(
            string: .AppSubscription.termsOfUse,
            attributes: [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        )
        it.attributedText = attributedString
        it.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_4.cgFloat
    }
    
    let privacyPolicyStartingText = Caption(label: .AppSubscription.privacyPolicyTermsOfUse)
    
    lazy var termsAndConditionStack = stack(hstack(privacyPolicyStartingText,privacyPolicy).wrapInUIView({ container, child in
        child.snp.makeConstraints { make in
            make.centerX.equalTo(container.snp.centerX)
        }
    }),hstack(UIView(),termsOfUse,UIView(),distribution: .equalCentering)).withHeight(40)
    
    lazy var bottomContainer = stack(
        VSpacer(40),
        redeemCouponLabel,
        VSpacer(20),
        restorePurchaseLabel,
        VSpacer(20),
        termsAndConditionStack,
        VSpacer(20)
    ).withMargins(.horizontal(20))
    
    
    lazy var mainStack = stack(
        titleText,
        VSpacer(20),
        subscriptionPlans,
        VSpacer(Dimension.SIZE_12),
        proceedButtonWithIcon,
        bottomContainer,
        VSpacer(20)
    )
    
    lazy var scrollView = UIScrollView().apply { it in
        it.keyboardDismissMode = .interactive
    }
    
    override func setupViews() {
        addSubViews(backButton,scrollView)
        scrollView.addSubViews(mainStack)
    }
    
    override func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimension.SIZE_8)
            make.top.equalToSuperview().offset(100)
        }

        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom)
        }
        
        titleText.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 20)
        }
        
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(10)
            make.centerX.equalTo(scrollView)
        }
    }
    
}
