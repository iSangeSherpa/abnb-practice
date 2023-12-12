//
//  AllReviewsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation

class AllReviewsViewController : ViewController<AllReviewsView,AllReviewsViewModel>{
    
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        bindAllReviewsItems()
    }
    
    
    private func bindAllReviewsItems(){
        viewModel.allReviewsItems
            .bind(to: binding.allReviewsCollection.rx.items(cellIdentifier: ReviewsItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! ReviewsItemCell
                cell.configure(model:item)
            }.disposed(by: disposeBag)
    }
    
    
}
