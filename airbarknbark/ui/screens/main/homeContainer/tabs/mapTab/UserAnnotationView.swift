//
//  UserAnnotationView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/12/2022.
//

import Foundation
import MapKit
import UIKit

class UserAnnotationView: MKAnnotationView {
    static let identifier = "UserAnnotationView"
    
    var imageView: UIImageView!
    var backgroundViewLayer1: UIView!
    var backgroundViewLayer2: UIView!
    
    var currentLocationView  = UIView().apply({ it in
        let currentLocationLabel =  Caption(label: "Your current Location")
        it.addSubview(currentLocationLabel)
        it.backgroundColor = .white
        currentLocationLabel.snp.makeConstraints { make in
            make.edges.equalTo(it).inset(10)
        }
    })
   
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func render(imageSize : CGFloat = 70.0){
        let imageSize = imageSize
        let bgLayer1Size = imageSize + 20.0
        let bgLayer2Size = bgLayer1Size + 20.0
        
        imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = imageSize/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.contentMode = .scaleAspectFill
        
        backgroundViewLayer1 = UIView().apply { it in
            it.backgroundColor = UIColor.primary.withAlphaComponent(0.08)
            it.layer.cornerRadius = (bgLayer1Size)/2
            it.layer.masksToBounds = true
        }
        backgroundViewLayer2 = UIView().apply { it in
            it.backgroundColor = UIColor.primary.withAlphaComponent(0.05)
            it.layer.cornerRadius = bgLayer2Size/2
            it.layer.masksToBounds = true
        }
        
        subviews.forEach { $0.removeFromSuperview() }
        
        self.addSubViews(backgroundViewLayer2,backgroundViewLayer1,imageView,currentLocationView)
       
        self.imageView.snp.makeConstraints { make in
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.backgroundViewLayer1.snp.makeConstraints { make in
            make.height.equalTo(bgLayer1Size)
            make.width.equalTo(bgLayer1Size)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.backgroundViewLayer2.snp.makeConstraints { make in
            make.height.equalTo(bgLayer2Size)
            make.width.equalTo(bgLayer2Size)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.currentLocationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(backgroundViewLayer2.snp.bottom)
        }
        
        self.snp.makeConstraints { make in
            make.top.bottom.equalTo(backgroundViewLayer2)
            make.left.right.equalTo(currentLocationView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
