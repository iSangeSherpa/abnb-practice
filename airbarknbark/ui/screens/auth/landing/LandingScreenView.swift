//
//  LandingPageView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/09/2022.
//

import Foundation
import UIKit

class LandingScreenView : BaseUIView{
    
    let centerImage  = UIImageView().apply{
        $0.image = UIImage(named: "landng_screen_center_image")
        $0.contentMode = .scaleAspectFit
    }
    
    let centerText = TitleH1(label: .airbark)
    
    lazy var pageControl = UIPageControl().apply {
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = .primary.withAlphaComponent(0.1)
        $0.currentPageIndicatorTintColor = .primary
        $0.addTarget(self, action: #selector(self.viewPagerPageDidChange(_:)), for: .valueChanged)
    }
    
    let getStartedButton =  PrimaryButton(label: .Landing.button)
    
    let bottomCaption =  Caption(label: .Landing.alreadyHaveAccount).apply() {
        $0.textAlignment = .right
    }
    
    let bottomCaptionLoginButton = TextButton(label: .Landing.login, color: .primary).apply { it in
        it.titleLabel?.textAlignment = .left
    }
    
    lazy var pagerScrolView = UIScrollView().apply {
        $0.showsHorizontalScrollIndicator = false
    }
    
    
    override func setupViews() {
        
        addSubview(centerImage)
        addSubview(centerText)
        addSubview(pagerScrolView)
        addSubview(pageControl)
        addSubview(getStartedButton)
        addSubview(bottomCaption)
        addSubview(bottomCaptionLoginButton)
        
    }
    
    
    override func setupConstraints(){
        
        print("window?.frame.height",UIScreen.main.bounds.height)

        let indicatorInset = UIScreen.main.bounds.height > 700 ? 40 : 10
        
        centerImage.snp.makeConstraints{ make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(centerText.snp.top)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(centerImage.snp.width)
        }
        
        pagerScrolView.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(200)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(getStartedButton.snp.top).offset( -indicatorInset)
            make.left.right.equalTo(self)
            make.height.equalTo(30)
        }
        
        getStartedButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottomMargin).inset(Dimension.SIZE_36)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.height.equalTo(50)
        }
        
        bottomCaption.snp.makeConstraints { make in
            make.top.equalTo(getStartedButton.snp.bottom).offset(Dimension.SIZE_8)
            make.centerX.equalTo(self.snp.centerX).offset(-Dimension.SCREEN_PADDING)
        }
        
        bottomCaptionLoginButton.snp.makeConstraints { make in
            make.lastBaseline.equalTo(bottomCaption)
            make.left.equalTo(bottomCaption.snp.right).offset(Dimension.SIZE_4)
        }
        
        animateCenterPageForPage(currentPage:0)
    }
    
    @objc  func viewPagerPageDidChange(_ sender : UIPageControl){
        let currentPage  = sender.currentPage
        pagerScrolView.setContentOffset( CGPoint(x:CGFloat(currentPage) * pagerScrolView.frame.size.width,y:0), animated: true)
    }
    
    
    func animateCenterPageForPage(currentPage:Int){
        let offset = currentPage == 0 ? 40 : currentPage == 1 ? 20 : -30

        centerText.snp.remakeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(pagerScrolView.snp.top).offset(offset)
            make.height.equalTo(50)
        }

        UIView.animate(withDuration: 0.2) { [self] in
            self.layoutSubviews()
        }
    }
    
    func createPagerPage(frame:CGRect) -> UILabel {
        return  UILabel(frame: frame).apply() {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .onBackground
            $0.font = .body
        }
    }
    
}
