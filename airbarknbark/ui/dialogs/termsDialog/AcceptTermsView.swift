//
//  TermsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 06/03/2023.
//

import Foundation
import WebKit

class AcceptTermsView : BaseUIView{
    let backButton = BackButton()
    
    let webView = WKWebView()
    
    let okButton = PrimaryButton(label: "Accept")
    
    let cancelButton = PrimaryButton(label: "Cancel").apply { it in
        it.backgroundColor = .background
        it.configuration  = UIButton.Configuration.filled()
        it.configuration?.baseBackgroundColor = .background
        it.setTitleColor(UIColor.onBackground, for: .normal)
        it.setTitleColor(UIColor.primary, for: .highlighted)
    }
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_8),
        webView,
        hstack(okButton,cancelButton,distribution: .fillEqually),
        VSpacer(Dimension.SIZE_12),
        spacing: Dimension.SIZE_4.cgFloat
    )
    
    override func setupViews() {
        addSubViews(backButton,containerStack)
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    override func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(Dimension.SIZE_8)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(Dimension.SIZE_16)
            make.left.right.bottom.equalToSuperview().inset(Dimension.SIZE_22)
        }
    }
}
