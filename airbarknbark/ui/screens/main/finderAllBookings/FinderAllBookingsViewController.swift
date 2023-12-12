//
//  HomeTabViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxSwift

class FinderAllBookingsViewController : ViewController<FinderAllBookingsView, FinderAllBookingsViewModel> {
    var parentController:HomeContainerScreenViewController? = nil
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        bindAllBookingItems()
        
        viewModel.onBookingsItemClicked.flatMap { requestId in
            return  FinderBookingDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = parentController
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
    
    
    private func bindAllBookingItems(){
        viewModel.allBookingItems
            .bind(to: binding.allBookingsCollection.rx.items(cellIdentifier: BookingItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! BookingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onBookingsItemClicked.accept(item.id)
                }
                
            }.disposed(by: disposeBag)
    }
    
    func result() -> Observable<Void>{
        return viewModel.triggerHomeRefresh.asObservable()
    }
}

