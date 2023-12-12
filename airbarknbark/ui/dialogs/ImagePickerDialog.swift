//
//  UserCaseUIViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 15/09/2022.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialDialogs

class ImageSourceDialogView : BaseUIView{
    
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let cancelButton = PrimaryButton(label: "Cancel").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "Select Image"),
        crossButton,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    lazy var optionGallery = getOptionRow(imageName: "ic_gallery", title: "Upload from gallery");
    lazy var optionCamera = getOptionRow(imageName: "ic_camera", title: "Take a Photo");
    
    lazy var containerStack = stack(
        titleHStack,
        VSpacer(Dimension.SIZE_4),
        optionGallery,
        VSpacer(1).apply{ it in
            it.backgroundColor = .onBackground.withAlphaComponent(0.1)
        },
        optionCamera,
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




