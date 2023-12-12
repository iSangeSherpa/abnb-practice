//
//  SubscriptionPaymentDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/07/2023.
//

import Foundation
import UIKit
import RxSwift

class SubscriptionPaymentDialogView : BaseUIView{
    let bannerImage = UIImageView(image: UIImage(named: "img_subscription_banner")).withHeight(300)
    let moreIcon = UIImageView(image: UIImage(systemName: "ellipsis")?.withRenderingMode(.alwaysTemplate)).withSize(22).apply { it in
        it.transform = it.transform.rotated(by: CGFloat(Double.pi/2))
        it.tintColor = .black
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.65)
    }
    
    let appLogo = UIImageView(image: UIImage(named: "splash_screen_logo")).withHeight(110).withWidth(210).wrapInUIView{ container, child in
        child.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    lazy var infoContainer = stack(
        LabelWithLeadingIcon(label : .AppSubscription.subscriptionInfoText1, icon : UIImage(named: "ic_check")!).container,
        LabelWithLeadingIcon(label : .AppSubscription.subscriptionInfoText2, icon : UIImage(named: "ic_check")!).container,
        LabelWithLeadingIcon(label : .AppSubscription.subscriptionInfoText3, icon : UIImage(named: "ic_check")!).container,
        LabelWithLeadingIcon(label : .AppSubscription.subscriptionInfoText4, icon : UIImage(named: "ic_check")!).container,
        spacing: 10
    )
    
    func LabelWithLeadingIcon(label : String, icon : UIImage) -> LabeWithTrailingIcon{
        let labelView = TextBody(label: label).apply { it in
            it.font = .bodyMedium.withSize(16)
            it.clipsToBounds = false
        }
        
        let iconView  = UIImageView(image: icon).apply { it in
            it.contentMode = .scaleAspectFit
            it.enableRipple(style: .unbounded)
            it.withSize(16)
        }
        
        return LabeWithTrailingIcon(
            label:labelView,
            icon: iconView,
            container: hstack(iconView, labelView,UIView(), spacing : 10, alignment: .center)
        )
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
        let attributedString = NSAttributedString(
            string: .AppSubscription.redeem,
            attributes: [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        )
        it.attributedText = attributedString
        it.isHidden = true
    }
    let restorePurchaseLabel = Caption(label: .AppSubscription.restorePurchase, font: .poppinsBold(fontSize: 14))
    
    let privacyPolicyStartingText = Caption(label: .AppSubscription.privacyPolicyTermsOfUse)
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
        it.isUserInteractionEnabled = true
        it.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_4.cgFloat
    }
    
    lazy var termsAndConditionStack = stack(hstack(privacyPolicyStartingText,privacyPolicy).wrapInUIView({ container, child in
        child.snp.makeConstraints { make in
            make.centerX.equalTo(container.snp.centerX)
        }
    }),hstack(UIView(),termsOfUse,UIView(),distribution: .equalCentering)).withHeight(40)
    
    lazy var bottomContainer = stack(
        VSpacer(20),
        subscriptionPlans,
        VSpacer(20),
        proceedButtonWithIcon,
        VSpacer(20),
        redeemCouponLabel,
        VSpacer(20),
        restorePurchaseLabel,
        VSpacer(20),
        termsAndConditionStack,
        VSpacer(20)
    ).withMargins(.horizontal(20))
    
    lazy var mainContainer = UIView().apply { it in
        it.addSubViews(bannerImage,appLogo,infoContainer,bottomContainer,moreIcon)
    }
    
    lazy var scrollView = UIScrollView().apply { it in
        it.addSubview(mainContainer)
    }
    override func setupViews() {
        addSubViews(scrollView)
        backgroundColor = .white
    }
    
    override func setupConstraints() {
    
        moreIcon.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
        }
    
        bannerImage.snp.makeConstraints { make in
            make.top.right.left.equalTo(mainContainer)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        appLogo.snp.makeConstraints { make in
            make.left.right.equalTo(bannerImage)
            make.bottom.equalTo(bannerImage).inset(100)
        }
        
        infoContainer.snp.makeConstraints { make in
            make.centerX.equalTo(mainContainer)
            make.top.equalTo(appLogo.snp.bottom).offset(70)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(infoContainer.snp.bottom)
            make.bottom.equalTo(mainContainer.snp.bottom)
        }
        
        mainContainer.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
