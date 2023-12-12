//
//  PastWorksViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation


class PastWorksViewController : ViewController<PastWorksView,PastWorksViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        bindAllReviewsItems()
        
    }
    
    
    private func bindAllReviewsItems(){
        viewModel.pastWorks
            .bind(to: binding.pastWorksCollection.rx.items(cellIdentifier: PastWorksItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! PastWorksItemCell
                cell.configure(model:item)
                cell.rx.tapGesture().when(.recognized).bind{
                    _ in
                    MindingForDetailsViewController().apply { [self] it in
                        it.viewModel.requestId = item.id
                        it.parentController = self.parentController
                        self.parentController?.navigationController?.pushViewController(it, animated: true)
                    }
                    
                }.disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    
}
