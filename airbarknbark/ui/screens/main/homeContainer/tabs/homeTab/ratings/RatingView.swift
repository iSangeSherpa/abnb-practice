//
//  RatingView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import UIKit
import RxSwift

class StarRatingView : UIView {
    
    var ratingsChangeListener : ((Int) -> Void)?
    
    var starRatings : Int = -1 {
        didSet{
            self.ratingImages.map { imageView in
                imageView.tintColor = UIColor(hexString: "#C8C8C8")
            }
            
            if(starRatings > 0){
                for i in 0...starRatings-1{
                    self.ratingImages[i].tintColor = UIColor(hexString: "#F8B84E")
                }
            }
            self.ratingsChangeListener?(starRatings)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
    }
    
    let ratingImages : [UIImageView] = [
        UIImageView(image: UIImage(named: "ic_paw")?.withRenderingMode(.alwaysTemplate)).withWidth(25).withHeight(20),
        UIImageView(image: UIImage(named: "ic_paw")?.withRenderingMode(.alwaysTemplate)).withWidth(25).withHeight(20),
        UIImageView(image: UIImage(named: "ic_paw")?.withRenderingMode(.alwaysTemplate)).withWidth(25).withHeight(20),
        UIImageView(image: UIImage(named: "ic_paw")?.withRenderingMode(.alwaysTemplate)).withWidth(25).withHeight(20),
        UIImageView(image: UIImage(named: "ic_paw")?.withRenderingMode(.alwaysTemplate)).withWidth(25).withHeight(20)
    ]
    
    lazy var containerStack = hstack(
        ratingImages[0],
        ratingImages[1],
        ratingImages[2],
        ratingImages[3],
        ratingImages[4],
        UIView(),
        spacing: Dimension.SIZE_22.cgFloat
    )
    
    private func setupView() {
        self.subviews.forEach({ $0.removeFromSuperview() })
        addSubview(containerStack)
        
        for i in 0...ratingImages.count-1{
            ratingImages[i].addOnClickListner {[unowned self] in
                self.starRatings = i+1
                self.setStarRating(starRatings: self.starRatings)
            }
        }
        setStarRating(starRatings: -1)
    }
    
    private func setupConstraints(){
        self.containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setStarRating(starRatings : Int){
        self.starRatings = starRatings
    }
    
    func addRatingsChangeListener(ratingsChangeListner : @escaping (Int) -> () ){
        self.ratingsChangeListener = ratingsChangeListner
    }
}

