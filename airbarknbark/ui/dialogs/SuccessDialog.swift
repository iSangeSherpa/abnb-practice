//
//  PopupDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit

class SuccessDialogView : BaseUIView{

    let titleLabel = TitleH2(label: .Dialog.sentSuccessTitle).apply { it in
        it.textColor = .primary
    }
    
    let bodyLabel = UILabel().apply({ it in
        it.font = UIFont.poppinsRegular(fontSize: 14)
        it.numberOfLines = 0
        it.text = .Dialog.sentSuccessBody
    })
 
    let thankYouButton = PrimaryButton(label: .Dialog.thankYou).apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var containerStack = stack(
        titleLabel,
        VSpacer(Dimension.SIZE_4),
        bodyLabel,
        VSpacer(Dimension.SIZE_8),
        thankYouButton,
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



