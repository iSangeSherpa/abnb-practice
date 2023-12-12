//
//  YourReviewsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit

class YourReviewsView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH2(label: "Your Reviews")
    
    let yourReviewsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(ReviewsItemTableViewCell.self, forCellReuseIdentifier: ReviewsItemTableViewCell.Identifier)
    }
   
    
    override func setupViews() {
        addSubViews(backButton,title,yourReviewsTableView)
    }
    
    override func setupConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimension.SIZE_2)
            make.top.equalToSuperview().offset(100)
            
        }
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimension.SCREEN_PADDING)
            make.top.equalTo(backButton.snp.bottom).offset(Dimension.SIZE_12)
        }

        yourReviewsTableView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

    }
    
   
}

