//
//  PopupUserCalloutViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/12/2022.
//

import Foundation
import UIKit
import MapKit
import SDWebImage

class PopoverUserCalloutViewController: UIViewController {
    private var dismissCallback: (() -> Void)?
    private var viewClickCallback: (() -> Void)?
    
    let imageSize = 90.0
    let imageView = UIImageView().withSize(90)
    var descriptionStack = UIView()
    var contentWrapper : UIStackView!
    let distanceLabel = Caption(label: "",font: .poppinsMedium(fontSize: 12))
    let nameLabel = TitleH3(label: "John Doe")
    
    let dialerButton = ButtonBox(icon: UIImage(named: "ic_dialer")).withSize(50)
    let messageButton = PrimaryButton(label: "Message").withHeight(50)
    let idVerifiedButton = IdVerifiedButton()
    
    lazy var bottomStack = hstack(
        HSpacer(Dimension.SIZE_8),
        dialerButton,
        HSpacer(Dimension.SIZE_4),
        messageButton,
        HSpacer(Dimension.SIZE_8),
        spacing: Dimension.SIZE_2.cgFloat,
        alignment: .center
    )
    
    
    override func viewDidLoad() {
        view.backgroundColor = .primary
        self.preferredContentSize =  CGSize(width: imageSize * 3, height: imageSize * 2)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.setupViews()
        self.setupConstraints()
      
    }
    
    
    func configure(annotation : UserAnnotation){
        self.nameLabel.text = annotation.name
        self.distanceLabel.text = annotation.distance
        self.imageView.loadImage(src: annotation.imageURL, type: .User)
        self.idVerifiedButton.isHidden = !annotation.isProfileVerified
        self.preferredContentSize =  CGSize(width: imageSize * 3, height: imageSize * (bottomStack.isHidden == true ? 1.3 : 2))
        self.view.layoutIfNeeded()
        
    }
    private func setupViews(){
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.primary.cgColor
        imageView.layer.borderWidth = 3
        imageView.image = UIImage(named: "user_placeholder")
        imageView.contentMode = .scaleAspectFill
        
        descriptionStack = stack(
            UIView(),
            hstack(nameLabel,UIView()),
            hstack(idVerifiedButton,UIView()),
            hstack(
                UIImageView(image: UIImage(named: "ic_path_distance")).withSize(16).apply({ it in
                    it.contentMode = .scaleAspectFit }),
                HSpacer(Dimension.SIZE_8),
                distanceLabel,
                UIView()
            ),
            UIView(),
            distribution: .equalCentering
        )
        
        contentWrapper = stack(
            VSpacer(Dimension.SIZE_8),
            hstack(
                HSpacer(Dimension.SIZE_8),
                imageView,
                HSpacer(Dimension.SIZE_22),
                descriptionStack,
                UIView()
            ),
            VSpacer(Dimension.SIZE_8),
            bottomStack,
            VSpacer(Dimension.SIZE_8)
        ).apply({ it in
            it.backgroundColor = .background
            it.layer.cornerRadius = 15
            it.layer.masksToBounds = true
            it.layer.borderColor = UIColor.primary.cgColor
            it.layer.borderWidth = 3
        })
        
        self.view.addSubViews(contentWrapper)
        
    }
    
    private func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
        }
        contentWrapper.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(13)
        }
    
    }
    
    func setDismissCallback(dismissCallback:(() -> Void)? = nil){
        self.dismissCallback = dismissCallback
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismissCallback?()
    }
}

