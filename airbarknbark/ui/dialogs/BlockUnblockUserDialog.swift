//
//  BlockUnblockUserDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/02/2023.
//

import Foundation
import UIKit
import RxSwift

class BlockUnblockAccountDialog : BaseUIView{
    
    let messageLabel = TitleH3(label: "Are you sure?").apply { it in
        it.numberOfLines = 0
        it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let okButton = PrimaryButton(label: "OK").apply { it in
        it.backgroundColor = .maroon
        it.configuration = UIButton.Configuration.filled()
        it.configuration?.baseBackgroundColor = .maroon
    }
    
    let cancelButton = PrimaryButton(label: "Cancel").apply { it in
        it.backgroundColor = .background
        it.configuration  = UIButton.Configuration.filled()
        it.configuration?.baseBackgroundColor = .background
        it.setTitleColor(UIColor.onBackground, for: .normal)
        it.setTitleColor(UIColor.primary, for: .highlighted)
    }
    
    lazy var containerStack = stack(
        messageLabel,
        VSpacer(Dimension.SIZE_8),
        hstack(okButton,HSpacer(Dimension.SIZE_16),cancelButton),
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
    
    static func showBlockUnblockAccountDialog(vc: UIViewController, message:String, buttonText:String = "Ok") -> Maybe<Void>{
        return .create{ [vc] maybe in
            let viewController = DialogViewController<BlockUnblockAccountDialog,ViewModel>().setupBy { dialog in
                
                dialog.binding.messageLabel.text = message
                dialog.binding.okButton.setTitle(buttonText, for: UIControl.State.normal )
               
                dialog.binding.cancelButton.addOnClickListner {
                    maybe(.completed)
                }
                
                dialog.binding.okButton.addOnClickListner {
                    maybe(.success(Void()))
                }
                
                dialog.binding.layoutIfNeeded()
            }
            vc.present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }
    }
    
}
 



