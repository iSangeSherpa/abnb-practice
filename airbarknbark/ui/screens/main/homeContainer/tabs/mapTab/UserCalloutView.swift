//
//  UserCalloutView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/12/2022.
//

import Foundation
import UIKit

class UserCallOutView : BaseUIView{
    let imageSize = 90.0
    let imageView = UIImageView()
    var descriptionStack = UIView()
    var contentWrapper : UIStackView!
    let distanceLabel = Caption(label: "1.3 km away",font:.poppinsMedium(fontSize: 12))
    let nameLabel = TitleH3(label: "John Doe")

    override func setupViews(){
        
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.primary.cgColor
        imageView.layer.borderWidth = 3
        imageView.image = UIImage(named: "user_placeholder")
        imageView.contentMode = .scaleAspectFit
        
        descriptionStack = stack(
            UIView(),
            hstack(
                 nameLabel,
                 UIImageView(image: UIImage(named: "ic_circle_check")).withWidth(12).apply({ it in
                     it.contentMode = .scaleAspectFit
                 }),
                 UIView(),
                 spacing: Dimension.SIZE_8.cgFloat
             ),
            hstack(
                UIImageView(image: UIImage(named: "ic_path_distance")).withWidth(16).apply({ it in
                    it.contentMode = .scaleAspectFit }),
                HSpacer(Dimension.SIZE_8),
                distanceLabel,
                UIView()
            ),
            UIView(),
            distribution: .equalCentering
        )
        
        contentWrapper = hstack(
            imageView,
            HSpacer(Dimension.SIZE_22),
            descriptionStack
        ).apply({ it in
            it.backgroundColor = .white
            it.layer.cornerRadius = 10
            it.layer.masksToBounds = true
            it.layer.borderColor = UIColor.primary.cgColor
            it.layer.borderWidth = 3
        })

        addSubViews(contentWrapper)
        
    }
    
    override func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
        }
        contentWrapper.snp.makeConstraints { make in
            make.height.equalTo(imageSize)
        }
        self.snp.makeConstraints { make in
            make.edges.equalTo(contentWrapper)
        }
    }
    
    func configure(annotation : UserAnnotation){
        self.nameLabel.text = annotation.name
        self.distanceLabel.text = annotation.distance
        self.imageView.loadImage(src: annotation.imageURL, type: .User)
    }
    
}
