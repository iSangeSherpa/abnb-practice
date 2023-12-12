//
//  MinderAllBookingsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 02/12/2022.
//

import Foundation
import RxSwift

class MinderAllBookingsViewController : ViewController<MinderAllBookingsView, MinderAllBookingsViewModel> {
    var parentController:HomeContainerScreenViewController? = nil
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        bindAllBookingItems()
        
        viewModel.onBookingsItemClicked.flatMap { requestId in
            return  MinderBookingDetailsViewController().apply { [self] it in
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

