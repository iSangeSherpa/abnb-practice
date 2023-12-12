//
//  EnableLocationView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/09/2023.
//

import Foundation
import UIKit

class EnableLocationView : BaseUIView{
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let searchButton = PrimaryButton(label: "Done").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "Location Service"),
        UIView(),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    let enableLocationInfoLabel  = InfoView(.Dialog.enableLocationServiceMessage, false)
  
    let buttonDone = PrimaryButton(label: "Enable").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var containerStack = stack(
        titleHStack,
        enableLocationInfoLabel,
        VSpacer(Dimension.SIZE_16),
        buttonDone,
        VSpacer(Dimension.SIZE_22),
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    override func setupViews(){
        addSubViews(containerStack)
    }
    
    
    override func setupConstraints(){
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
       
    }
}
