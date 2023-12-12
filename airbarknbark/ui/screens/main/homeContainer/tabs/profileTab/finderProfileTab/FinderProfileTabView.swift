//
//  HomeTabView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit

class FinderProfileTabView : BaseUIView{

    
    let refreshControl = UIRefreshControl()
    
    lazy var scrollView  = UIScrollView().apply { it in
        it.refreshControl = refreshControl
    }
    
    let profileIncompleteLabel = Caption(label: "Your profile is in the process of verification.", color: .error)
    
    lazy var notVerifiedMessage = hstack(
        UIView(),
        UIImageView(icon: "ic_i_icon", tint: .error).withWidth(12),
        HSpacer(4),
        profileIncompleteLabel,
        UIView()
    )
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(80).apply{ it in
        it.layer.cornerRadius = (80)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }

    let userName = TitleH3(label: "David Musk")
    
    let location = Caption(label: "New Jersey 45463",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
    let phoneNumber = Caption(label: "+1 892374122",font: .poppinsMedium(fontSize: 12),alpha: 0.8)
    lazy var phoneContainer = hstack(UIImageView(icon: "ic_dialer_outline", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
                                     phoneNumber)
    lazy var locationWithContacts = hstack(
        UIImageView(icon: "ic_location", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
        location,
        HDivider(verticalMargin: 8),
        phoneContainer,
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    let changeUserType =  PrimaryButton(label: "Be a Minder", height: 42, cornerRadius: 4).apply{ (it:UIButton) in
        it.setImage(UIImage(named: "ic_person")?.scaledDown(into: .init(width: 14, height: 14)).withTintColor(.onBackground), for: .normal)
        it.configuration?.imagePadding = 8
        it.configuration?.baseBackgroundColor = .init(hexString: "#F2F2F2")
        it.layer.cornerRadius = 8
        it.setTitleColor(UIColor.onBackground, for: .normal)
        it.setTitleColor(UIColor.onBackground, for: .highlighted)
    }
    
    let editProfileButton = PrimaryButton(label: "Edit Profile", height: 42, cornerRadius: 8).apply{ (it:UIButton) in
        it.setImage(UIImage(named: "ic_edit_profile")?.scaledDown(into: .init(width: 16, height: 16)), for: .normal)
        it.configuration?.imagePadding = 8
    }
    lazy var actionButtons = hstack(
        editProfileButton,
        changeUserType,
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    lazy var changePasswordActionItem = ProfileActionItem(label:"Change Password")
    lazy var yourPetsActionItem =  ProfileActionItem(label:"Your Pets")
    lazy var yourDocumentsActionItem = ProfileActionItem(label:"Your Documents")
    lazy var blockedUsersActionItem = ProfileActionItem(label:"Blocked Users")
    lazy var deleteAccountActionItem = PrimaryButton(label: "Delete Account").apply { it in
        it.setTitleColor(UIColor(hexString: "#CB4040"), for: .normal)
        it.backgroundColor = .surface
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.configuration = UIButton.Configuration.filled()
        it.configuration?.baseBackgroundColor = .surface
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 8
        it.enableRipple().rippleView.layer.cornerRadius = 8
        it.setTitle("Delete Account", for:.normal)
      
    }
    lazy var logoutActionItem = PrimaryButton(label: "Logout")
    lazy var choosePreferredCurrencyItem = ProfileActionItem(label:"Preferred Currency", trailingView: Caption(label: "AUD", color: .primary, font: .poppinsSemibold(fontSize: 12)))
    lazy var privacyPolicyItem = ProfileActionItem(label:"Privacy Policy")
    lazy var termsOfUseItem = ProfileActionItem(label:"Terms of Use")
    lazy var currentPaymentItem = ProfileSubscriptionItem(plan: "Current: $4.97 Monthly Plan")

    let notificationSwitch = UISwitch().apply { it in
        it.isOn = true
    }
    
    lazy var menuItems = stack(
        changePasswordActionItem,
        yourPetsActionItem,
        yourDocumentsActionItem,
        blockedUsersActionItem,
        choosePreferredCurrencyItem,
        ProfileActionItem(label:"Notifications", hasRightArrow: false, trailingView: notificationSwitch),
        VSpacer(Dimension.SIZE_8),
        currentPaymentItem,
        privacyPolicyItem,
        termsOfUseItem,
        deleteAccountActionItem,
        logoutActionItem,
        spacing: Dimension.SIZE_12.cgFloat
    )
    
    lazy var containerStack = stack(
        notVerifiedMessage,
        VSpacer(Dimension.SIZE_8),
        avatarImage,
        VSpacer(Dimension.SIZE_8),
        userName,
        locationWithContacts,
        VSpacer(Dimension.SIZE_8),
        actionButtons,
        VSpacer(Dimension.SIZE_22),
        menuItems,
        alignment: .center
    )
    
    func ProfileActionItem(
        label:String =  "Change Password",
        hasRightArrow:Bool = true,
        trailingView:UIView? = nil
    ) -> UIView{
        hstack(
            Caption(label: label, font: .poppinsMedium(fontSize: 12)),
            UIView(),
            spacing:Dimension.SIZE_8.cgFloat,
            alignment: .center
        ).withMargins(.horizontal(20))
        .withHeight(60)
        .apply { it in
            it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
            it.layer.borderWidth = 1
            it.layer.cornerRadius = 8
            it.backgroundColor = .surface
            it.enableRipple().rippleView.layer.cornerRadius = 8
            
            if let trailingView = trailingView{
                it.addArrangedSubview(trailingView)
            }
        
            if(hasRightArrow){
                it.addArrangedSubview(UIImageView(icon: "ic_arrow_right").withSize(16))
            }
        }
    }
    
    override func setupViews() {
        backgroundColor  = .background
        addSubview(scrollView)
        scrollView.addSubview(containerStack)
    }
    
    override func setupConstraints() {
        
        actionButtons.subviews.forEach { it in
            it.snp.makeConstraints { make in
                make.width.equalTo(self).multipliedBy(0.35)
            }
        }
        
        menuItems.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
    }
}
