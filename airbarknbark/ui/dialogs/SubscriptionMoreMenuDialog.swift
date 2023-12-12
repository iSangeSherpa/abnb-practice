//
//  SubscriptionMoreMenuDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 27/09/2023.
//

import Foundation
import UIKit

class SubscriptionMoreMenuDialog : BaseUIView{
    
    static let DELETE_ACCOUNT = 1
    static let LOGOUT = 2
    
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let cancelButton = PrimaryButton(label: "Cancel").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "More"),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    lazy var optionDeleteAccount = getOptionRow(imageName: "delete", title: "Delete Account");
    lazy var optionLogout = getOptionRow(imageName: "delete", title: "Logout");
    
    lazy var containerStack = stack(
        titleHStack,
        VSpacer(Dimension.SIZE_4),
        optionDeleteAccount,
        VSpacer(1).apply{ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        },
        optionLogout,
        VSpacer(1).apply{ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        },
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    func getOptionRow(imageName:String, title:String) -> UIStackView{
        return hstack(
            UIImageView(image: UIImage(systemName: imageName)).apply{ it in
                it.withSize(Dimension.SIZE_22.cgFloat)
                it.contentMode = .scaleAspectFill
                it.isHidden = true
            },
            TextBody(label: title).apply { it in
                it.font = .bodyMedium
                it.textAlignment = .left
            },
            spacing: Dimension.SIZE_8.cgFloat,
            alignment: .center,
            distribution: .fill
        ).apply { it in
            it.layer.cornerRadius = Dimension.DEFAULT_BUTTON_CORNER_RADIUS
            it.withMargins(UIEdgeInsets.allSides(Dimension.SIZE_12.cgFloat))
            it.enableRipple().rippleView.layer.cornerRadius = Dimension.DEFAULT_BUTTON_CORNER_RADIUS
        }
    }
    
    
    override func setupViews() {
        addSubview(containerStack)
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    override func setupConstraints() {
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
        
    }
}


