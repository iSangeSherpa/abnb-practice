//
//  buttons.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import UIKit


func TextButton(
    label:String,
    color:UIColor  = .onBackground,
    font:UIFont = .captionSemiBold
) -> UIButton{
    
    return UIButton().apply {
        $0.setTitle(label, for:.normal)
        $0.configuration = UIButton.Configuration.plain()
        $0.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = font
            outgoing.foregroundColor = color
            return outgoing
        })
        $0.sizeToFit()
        $0.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_8.cgFloat
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
}

func BackButton() -> UIButton{
    return UIButton().apply { it in
        it.withWidth(50)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.65)
        it.contentMode = .center
        it.setBackgroundImage(UIImage(named: "ic_back_black"), for: .normal)
    }
}

func CrossButton(size:Int = 32) -> UIButton{
    return UIButton().apply { it in
        it.withSize(CGSize(width: size, height: size))
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.65)
        it.contentMode = .scaleAspectFit
        it.setBackgroundImage(UIImage(named: "ic_cross"), for: .normal)
    }
}

func IdVerifiedButton(showText:Bool = true) -> UIView{
    
    return UIView().apply { it in
        let imageView = UIImageView(image: UIImage(named: "ic_circle_check")).withSize(16).apply({ it in
            it.contentMode = .scaleAspectFit
            it.addOnClickListner {
                UIAlertController(title: "Status", message: "ID Verified", preferredStyle: UIAlertController.Style.alert).apply { alert in
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { [weak alert] (_) in
                        alert?.dismiss(animated: true)
                    }))
                    alert.view.tintColor = .primary
                    var rootViewController = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first?.rootViewController
                    if let navigationController = rootViewController as? UINavigationController {
                        rootViewController = navigationController.viewControllers.first
                    }
                    if let tabBarController = rootViewController as? UITabBarController {
                        rootViewController = tabBarController.selectedViewController
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
                        rootViewController?.present(alert, animated: true)
                    }
                }
            }
        })
        
        let verifiedText = Caption(label: "ID Verified",font: .poppinsSemibold(fontSize: 13)).apply { it in
            it.textColor = UIColor(hexString: "#3C9672")
        }
        
        it.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        if(showText){
            it.addSubview(verifiedText)
            verifiedText.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-4)
                make.right.top.bottom.equalToSuperview()
            }
        }
        
    }
}


func PrimaryButton(
    label:String,
    font:UIFont = .poppinsMedium(fontSize: 14),
    height: Int =  Dimension.PRIMARY_BUTTON_HEIGHT,
    cornerRadius: Double = Dimension.DEFAULT_BUTTON_CORNER_RADIUS
) -> UIButton{
    
    return UIButton().apply {
        $0.backgroundColor = .primary
        $0.setTitle(label, for:.normal)
        $0.layer.cornerRadius = cornerRadius
        $0.configuration = UIButton.Configuration.filled()
        $0.configuration?.baseBackgroundColor = .primary
        $0.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        })
        $0.withHeight(height.cgFloat)
        $0.enableRipple(rippleColor: .onPrimary.withAlphaComponent(0.1))
    }
}

func PrimaryButtonOutline(
    label:String,
    borderColor:UIColor = .primary,
    font:UIFont = .poppinsMedium(fontSize: 14),
    titleColor: UIColor = .onBackground,
    cornerRadius : Double = Dimension.DEFAULT_BUTTON_CORNER_RADIUS,
    height: Int = Dimension.PRIMARY_BUTTON_HEIGHT
) -> UIButton{
    return  UIButton().apply {
        $0.setTitle(label, for:.normal)
        $0.backgroundColor = .clear
        $0.setTitleColor(titleColor, for: .normal)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = borderColor.cgColor
        $0.titleLabel?.font = font
        $0.layer.cornerRadius = cornerRadius
        $0.withHeight(height.cgFloat)
        $0.enableRipple().rippleView.layer.cornerRadius = cornerRadius
    }
}


func ButtonBox(
    icon:UIImage?,
    size:Int = Dimension.PRIMARY_BUTTON_HEIGHT
) -> UIView {
    return UIImageView(image: icon)
        .withSize(Dimension.SIZE_16.cgFloat)
        .wrapInUIView { container, child in
            child.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            container.withSize(size.cgFloat)
            container.backgroundColor = .background
            container.layer.cornerRadius = 2
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.1).cgColor
            container.enableRipple().rippleView.layer.cornerRadius = 2
        }
}
