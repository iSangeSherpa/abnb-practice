//
//  SentForVerificationDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 25/11/2022.
//

import Foundation
import UIKit
import RxSwift

class PopupDialogView : BaseUIView{
    
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
        it.text = .Dialog.sentSuccessBody
        it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
    })
    
    let okButton = PrimaryButton(label: "OK").apply { it in
//        it.withWidth(UIScreen.main.bounds.width)
    }
    let cancelButton = PrimaryButton(label: "Cancel").apply { it in
        it.backgroundColor = .background
        it.configuration  = UIButton.Configuration.filled()
        it.configuration?.baseBackgroundColor = .background
        it.setTitleColor(UIColor.onBackground, for: .normal)
        it.setTitleColor(UIColor.primary, for: .highlighted)
    }
    
    lazy var containerStack = stack(
        titleHStack,
        VSpacer(Dimension.SIZE_4),
        bodyLabel,
        VSpacer(Dimension.SIZE_8),
        hstack(okButton,cancelButton, distribution: .fillEqually),
        spacing: Dimension.SIZE_2.cgFloat
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
    
    static func showPopupDialog(vc: UIViewController, title:String, body:String, buttonText:String = "Ok",buttonColor:UIColor = .primary,showCancel:Bool = false) -> Maybe<Void>{
        return .create{ [vc] maybe in
            let viewController = DialogViewController<PopupDialogView,ViewModel>().setupBy { dialog in
                
                dialog.binding.titleLabel.text = title
                dialog.binding.bodyLabel.text = body
                dialog.binding.okButton.setTitle(buttonText, for: .normal)
                dialog.binding.okButton.setBackgroundColor(buttonColor, for: .normal)
                dialog.binding.okButton.configuration?.baseBackgroundColor = buttonColor
                
                dialog.binding.crossButton.addOnClickListner {
                    maybe(.completed)
                }
                
                dialog.binding.okButton.addOnClickListner {
                    maybe(.success(Void()))
                }
                
                dialog.binding.cancelButton.addOnClickListner {
                    maybe(.completed)
                }
                
                dialog.binding.cancelButton.isHidden = !showCancel
                
                
                dialog.binding.layoutIfNeeded()
            
            }
            vc.present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }
    }
    
}
