//
//  DeclineRequestWithMessageDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/02/2023.
//

import Foundation
import UIKit
import RxSwift

class DeclineRequestWithMessageDialog : BaseUIView{
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let declineRequest = PrimaryButton(label: "Decline, Send message").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    let messagePlaceholder = Caption(label: "Type your message").apply { it in
        it.textColor =  UIColor(hexString:"#8C8C8C")
    }
    
    let messageTextView = UITextView().withHeight(100).apply { it in
        it.font = .poppinsRegular(fontSize: 14)
        it.textColor = .onBackground
    }
    
    lazy var messageTextViewWrapper = messageTextView.wrapInUIView { container, child in
        container.backgroundColor = UIColor(hexString: "#F4F4F4")
        child.backgroundColor = UIColor(hexString: "#F4F4F4")
        let textView = (child as! UITextView)
        child.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        child.addSubViews(messagePlaceholder)
        messagePlaceholder.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(10)
        }
    }
    
    lazy var containerStack = stack(
        hstack(UIView(),crossButton),
        VSpacer(Dimension.SIZE_8),
        messageTextViewWrapper,
        VSpacer(Dimension.SIZE_8),
        declineRequest,
        spacing: Dimension.SIZE_2.cgFloat
    )
    
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
    
    static func showDeclineWithMesssageDialog(vc: UIViewController) -> Maybe<String>{
        return .create{ maybe in
            let dialogVc = DialogViewController<DeclineRequestWithMessageDialog,ViewModel>().setupBy { dialog in
                dialog.binding.messageTextView.rx.text.orEmpty.bind{
                    dialog.binding.messagePlaceholder.isHidden = !$0.isEmpty
                }.disposed(by: dialog.disposeBag)
                
                dialog.binding.declineRequest.rx.tapGesture().when(.recognized).bind{ _ in
                    maybe(.success(dialog.binding.messageTextView.text))
                }.disposed(by: dialog.disposeBag)
                
                dialog.binding.crossButton.rx.tapGesture().when(.recognized).bind{ _ in
                    maybe(.completed)
                }.disposed(by: dialog.disposeBag)
            }
            vc.present(dialogVc, animated: true)
            return Disposables.create {
                vc.dismiss(animated: true)
            }
        }
    }
}
