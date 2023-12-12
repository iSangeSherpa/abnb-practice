//
//  JoiningAsDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 08/11/2022.
//

import Foundation
import UIKit


class JoiningAsDialogView : BaseUIView{
    
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let cancelButton = PrimaryButton(label: "Cancel").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "You are joining as"),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    lazy var optionMinder = getOptionRow(imageName: "ic_tab_profile", title: "I am a Minder");
    lazy var optionFinder = getOptionRow(imageName: "ic_location_person", title: "I am a Finder");
    lazy var optionBoth = getOptionRow(imageName: "ic_profile_both", title: "Both (Minder + Finder)");
    
    lazy var containerStack = stack(
        titleHStack,
        Caption(label: "(You can be both, but please start with the one that best suits your needs)").apply({ it in
            it.textAlignment = .left
            it.alpha = 0.6
        }),
        VSpacer(Dimension.SIZE_4),
        optionMinder,
        VSpacer(1).apply{ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        },
        optionFinder,
        VSpacer(1).apply{ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        },
        optionBoth,
        VSpacer(Dimension.SIZE_16),
        cancelButton,
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    func getOptionRow(imageName:String, title:String) -> UIStackView{
        return hstack(
            UIImageView(image: UIImage(named: imageName)).apply{ it in
                it.withSize(Dimension.SIZE_22.cgFloat)
                it.contentMode = .scaleAspectFill
            },
            TextBody(label: title).apply { it in
                it.font = .bodyMedium
                it.textAlignment = .left
            },
            spacing: Dimension.SIZE_8.cgFloat,
            alignment: .center,
            distribution: .fill
        ).apply { it in
            it.layer.cornerRadius = Dimension.DEFAULT_BUTTON_CORNER_RADIUS
            it.withMargins(UIEdgeInsets.allSides(Dimension.SIZE_12.cgFloat))
            it.enableRipple().rippleView.layer.cornerRadius = Dimension.DEFAULT_BUTTON_CORNER_RADIUS
        }
    }
    
    
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
}



