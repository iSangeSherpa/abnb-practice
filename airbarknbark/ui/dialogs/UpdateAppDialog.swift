//
//  UpdateAppDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 29/05/2023.
//

import Foundation
import UIKit
import RxSwift

class UpdateAppDialogView : BaseUIView{
    
    let titleLabel = TitleH2(label: .Dialog.sentSuccessTitle)
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    lazy var titleHStack = hstack(
        titleLabel,
        HSpacer(Dimension.SIZE_22),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    let bodyLabel = UILabel().apply({ it in
        it.font = UIFont.poppinsRegular(fontSize: 14)
        it.numberOfLines = 0
        it.text = .newVersionAvailable
        it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        it.sizeToFit()
    }).withHeight(90)

    let okButton = PrimaryButton(label: "OK").apply { it in
//        it.withWidth(UIScreen.main.bounds.width)
        it.backgroundColor = .systemPink
    }
    
    let cancelButton = PrimaryButton(label: "Update").apply { it in
        it.backgroundColor = .background
        it.configuration  = UIButton.Configuration.filled()
        it.configuration?.baseBackgroundColor = .background
        it.setTitleColor(UIColor.onBackground, for: .normal)
        it.setTitleColor(UIColor.primary, for: .highlighted)
    }
    
    lazy var containerStack = stack(
        titleHStack,
        bodyLabel,
        hstack(okButton,cancelButton).padTop(5),
        distribution: .fill
    )
    
    override func setupViews() {
        addSubview(containerStack)
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    override func setupConstraints() {
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
    
    }
    
    static func showPopupDialog(vc: UIViewController, appUrl:String,title:String, body:String, buttonText:String = "Update",buttonColor:UIColor = .primary,showCancel:Bool = false) -> Maybe<Void>{
        return .create{ [vc] maybe in
            let viewController = DialogViewController<UpdateAppDialogView,ViewModel>().setupBy { dialog in
                
                dialog.binding.titleLabel.text = title
                dialog.binding.bodyLabel.text = body
                dialog.binding.okButton.setTitle(buttonText, for: .normal)
                dialog.binding.okButton.setBackgroundColor(buttonColor, for: .normal)
                dialog.binding.okButton.configuration?.baseBackgroundColor = buttonColor
                
                dialog.binding.crossButton.addOnClickListner {
                    maybe(.completed)
                }
                
                dialog.binding.okButton.addOnClickListner {
                    if let url = URL(string: appUrl),
                       UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    maybe(.success(Void()))
                }
                
                dialog.binding.cancelButton.addOnClickListner {
                    maybe(.completed)
                }
                
                dialog.binding.cancelButton.isHidden = !showCancel
                dialog.binding.crossButton.isHidden = !showCancel
                
                dialog.binding.layoutIfNeeded()
                }
            vc.present(viewController, animated: true, completion: {
                viewController.view.superview?.subviews[0].isUserInteractionEnabled = false
            })
            
            
            return Disposables.create {
                //                viewController.dismiss(animated: true)
            }
        }
    }
}
