//
//  MinderAllRequestsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/12/2022.
//

import Foundation


import RxSwift

class MinderAllRequestsViewController : ViewController<MinderAllRequestsView, MinderAllRequestsViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        bindAllRequestItems()
        
        viewModel.onRequestItemClicked.flatMap { requestId in
            return  MinderRequestDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                self.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.navigationController?.popViewController(animated: false)
                self.viewModel.triggerHomeRefresh.accept(Void())
            }
        }.disposed(by: disposeBag)
  
        
    }
    
    func bindAllRequestItems(){
        viewModel.allRequestItems
            .bind(to: binding.allRequestsCollection.rx.items(cellIdentifier: MindingRequestItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MindingRequestItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onRequestItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
    }
    
    func result() -> Observable<Void>{
        return viewModel.triggerHomeRefresh.asObservable()
    }
}

