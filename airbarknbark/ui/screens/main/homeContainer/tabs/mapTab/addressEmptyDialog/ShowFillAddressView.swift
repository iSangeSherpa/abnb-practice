//
//  ShowFillAddressView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/08/2023.
//

import Foundation
import UIKit

class ShowFillAddressView : BaseUIView{
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let searchButton = PrimaryButton(label: "Done").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "Address"),
        UIView(),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    let addressTrailingView = UIImageView(image:UIImage(named: "ic_location")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let addressDeleteView = UIImageView(image:UIImage(named: "ic_minus")).apply { it in
        it.contentMode = .scaleAspectFit
    }
    let addressLabel = Caption(label: "Address",font: .poppinsMedium(fontSize: 12))
    
    lazy var addressField = OutlineLabelOn(label: .RegisterVerification.addressOptional){ parent in
        let stack = hstack(addressLabel,
                           UIView(),
                           addressTrailingView,
                           UIView().withWidth(10),
                           addressDeleteView.withWidth(20).withHeight(20))
        parent.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalTo(parent).inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
        }
    }
    
    let addressFieldPressable = UIView()
    
    let buttonDone = PrimaryButton(label: "Done").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var containerStack = stack(
        titleHStack,
        VSpacer(Dimension.SIZE_22),
        addressField,
        VSpacer(Dimension.SIZE_22),
        buttonDone,
        VSpacer(Dimension.SIZE_22),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    override func setupViews(){
        addSubViews(containerStack,addressFieldPressable)
    }
    
    
    override func setupConstraints(){
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
        addressFieldPressable.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(addressField)
            make.right.equalTo(addressDeleteView.snp.left).offset(-10)
        }
    }
}
