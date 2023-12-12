//
//  RecentSessionsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 26/12/2022.
//

import Foundation

class RecentSessionsViewController : ViewController<RecentSessionsView,RecentSessionViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    
   override func setupView() {
       binding.backButton.rx.tap
           .bind(to: viewModel.dismissBy)
           .disposed(by: disposeBag)
       bindRecentSessions()
       
   }
   
   private func bindRecentSessions(){
       viewModel.recentSessions
           .bind(to: binding.pastWorksCollection.rx.items(cellIdentifier: PastWorksItemCell.Identifier)){  [self] (row, item, cell)  in
               let cell = cell as! PastWorksItemCell
               cell.configure(model:item)
               cell.rx.tapGesture().when(.recognized).bind{
                   _ in
                   FindingForDetailsViewController().apply { [self] it in
                       it.viewModel.requestId = item.id
                       it.parentController = self.parentController
                       self.parentController?.navigationController?.pushViewController(it, animated: true)
                   }
                   
               }.disposed(by: cell.disposeBag)
           }.disposed(by: disposeBag)
   }
   
}
