//
//  YourReviewsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit
import RxSwift

class YourReviewsViewController : ViewController<YourReviewsView,YourReviewsViewModel>{
    
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        bindReviewsItems()
    }
    
    
    func bindReviewsItems(){
        viewModel.reviews.bind(to: binding.yourReviewsTableView.rx.items(cellIdentifier: ReviewsItemTableViewCell.Identifier)){  [self] (row, item, cell)  in
            let cell = cell as! ReviewsItemTableViewCell
            cell.configure(model:item)
        }.disposed(by: disposeBag)
        
    }
    
    
}
