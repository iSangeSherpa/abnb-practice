//
//  SplashScreenView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import UIKit

class SplashScreenView : BaseUIView{
    
    
    let topImage = UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_top_image")
        $0.contentMode = .scaleAspectFill
    }
    
    
    let centerView = UIImageView().apply {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let bottomImage = UIImageView().apply {
        $0.image =  UIImage(named: "splash_screen_bottom_image")
        $0.contentMode = .scaleAspectFit
    }

    let progressView = UIActivityIndicatorView(style: .large)
    
   
    override func setupViews() {
        backgroundColor = .primary.withAlphaComponent(0.25)
        
        addSubview(topImage)
        addSubview(centerView)
        addSubview(bottomImage)
        addSubview(progressView)
    }
    
    
   override func setupConstraints(){
        topImage.snp.makeConstraints {  make in
            
            make.top.equalTo(self.snp.top)
            make.left.right.equalTo(self)
        }
    
        centerView.snp.makeConstraints {  make in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(self).multipliedBy(0.5)
        }
        
        bottomImage.snp.makeConstraints {  make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottomMargin)
            make.width.equalTo(self).multipliedBy(0.4)
        }
       
       progressView.snp.makeConstraints { make in
           make.centerX.equalToSuperview()
           make.top.equalTo(centerView.snp.bottom).offset(32)
           make.bottom.equalTo(bottomImage.snp.top)
       }
    }
    
}
