//
//  SetupProfilePetCell.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 20/09/2022.
//

import Foundation
import UIKit
import RxSwift



class RemovableItemWithLabel : BaseUICollectionViewCell{
    
    let image = UIImageView(image: nil).apply { it in
        it.contentMode = .scaleAspectFill
        it.clipsToBounds = true
    }
    
    let minusIcon = UIImageView(image: UIImage(named: "ic_minus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple()
    }
    
    let label = Caption(label: "").apply { it in
        it.font = .captionTinyMedium
        it.numberOfLines = 0
    }
    
    override func setupViews() {
        addSubViews(image,label, minusIcon)
        clipsToBounds = false
    }
    
    override func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.height.equalTo(40)
            make.bottom.equalTo(label.snp.top )
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(Dimension.SIZE_12)
        }
        
        minusIcon.snp.makeConstraints { make in
            make.top.equalTo(image)
            make.left.equalTo(image.snp.right).offset(-Dimension.SIZE_8)
            make.height.width.equalTo(Dimension.SIZE_16)
        }
        
    }

}
