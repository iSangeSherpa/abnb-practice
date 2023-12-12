//
//  ErrorDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation

import UIKit

class ErrorDialogView : BaseUIView{

    let titleLabel = TitleH2(label: .Dialog.failedTitle).apply { it in
        it.textColor = .primary
        it.textColor =  UIColor(hexString: "#CB4040")
    }
    
    let bodyLabel = UILabel().apply({ it in
        it.font = UIFont.poppinsRegular(fontSize: 14)
        it.numberOfLines = 0
        it.text = .Dialog.failedBody
    })
 
    let tryAgainButton = PrimaryButton(label: .Dialog.thankYou).apply { it in
        it.withWidth(UIScreen.main.bounds.width)
        it.backgroundColor = UIColor(hexString: "#CB4040")
        it.configuration?.baseBackgroundColor = UIColor(hexString: "#CB4040")
    }
    
    lazy var containerStack = stack(
        titleLabel,
        VSpacer(Dimension.SIZE_4),
        bodyLabel,
        VSpacer(Dimension.SIZE_8),
        tryAgainButton,
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
        
        bodyLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
    }
}



