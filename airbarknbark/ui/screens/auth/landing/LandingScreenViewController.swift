//
//  LandingScreenViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 06/09/2022.
//

import Foundation
import UIKit
import SnapKit

class LandingScreenViewController : ViewController<LandingScreenView, ViewModel>, UIScrollViewDelegate {
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViewPager()
    }
    
    override func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        binding.pagerScrolView.delegate = self
        binding.bottomCaptionLoginButton.isUserInteractionEnabled = true
        binding.bottomCaptionLoginButton.addOnClickListner { [unowned self] in
            navigationController?.pushViewController(LoginScreenViewController(), animated:true)
        }
        binding.getStartedButton.addOnClickListner { [unowned self] in
            navigationController?.pushViewController(RegisterScreenViewController(), animated:true)
        }
    }
    
    
    func configureViewPager(){
        let pagerTexts = [String.Landing.pagerText1, .Landing.pagerText2, .Landing.pagerText3]
        let width = CGFloat(binding.pagerScrolView.frame.size.width)
        let height = CGFloat(binding.pagerScrolView.frame.size.height)
        
        binding.pagerScrolView.contentSize = CGSize(width: width * CGFloat(pagerTexts.count), height: height)
        binding.pagerScrolView.isPagingEnabled = true
        
        for (index,item) in pagerTexts.enumerated() {
            let frame  = CGRect(x: CGFloat(index) * width , y: 0, width: width, height: height)
            let page = binding.createPagerPage(frame: frame).apply() {
                $0.text = item
            }
            
            binding.pagerScrolView.addSubview(page)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(Float(scrollView.contentOffset.x)/Float(scrollView.frame.size.width))
        binding.pageControl.currentPage = currentPage
        
        let page = Int((Float(scrollView.contentOffset.x)/Float(scrollView.frame.size.width)).rounded(.up))
        binding.animateCenterPageForPage(currentPage: page)
    }
}
