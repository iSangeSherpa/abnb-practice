//
//  MinderHomeTabViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import UIKit
import RxSwift

class MinderHomeTabViewController  : ViewController<MinderHomeTabView, MinderHomeTabViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    override func setupView() {
        binding.refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: {
                self.binding.refreshControl.endRefreshing()
                self.viewModel.getMindingRequests()
                
            })
            .disposed(by: disposeBag)
        
        viewModel.name.bind(to: binding.userHeader.rx.text).disposed(by: disposeBag)
        viewModel.greeting.bind(to: binding.userGreeting.rx.text).disposed(by: disposeBag)
       
        viewModel.hasUnreadNotification.bind{
            self.binding.updateNotificationIcon(hasUnreadNotification: $0)
        }.disposed(by: disposeBag)
        
        binding.notificationIcon.addOnClickListner {[unowned self] in
            NotificationsViewController().apply { it in
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result().bind{
                //Refresh Home Data
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){
                    self.viewModel.getMindingRequests()
                }
            }.disposed(by: self.disposeBag)
        }
        
        binding.availabilitySwitch
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(binding.availabilitySwitch.rx.value)
            .bind(to: viewModel.availabilitySwitchChanged)
            .disposed(by: disposeBag)
        
        //When Request's see all button clicked
        binding.viewAllRequestsButton.addOnClickListner { [unowned self] in
            self.viewModel.onSeeAllRequestsClicked.accept(Void())
        }
    
        viewModel.onSeeAllRequestsClicked.flatMap { requestId in
            return  MinderAllRequestsViewController().apply { [self] it in
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getMindingRequests()
        }.disposed(by: disposeBag)
        
        //When Bookings's see all button clicked
        binding.viewAllBookingsButton.addOnClickListner { [unowned self] in
            self.viewModel.onSeeAllBookingsClicked.accept(Void())
        }
        
        viewModel.onSeeAllBookingsClicked.flatMap { requestId in
            return  MinderAllBookingsViewController().apply { [self] it in
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getMindingRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onActiveMindingItemClicked.flatMap { requestId in
            return  MindingForDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getMindingRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onRequestsItemClicked.flatMap { requestId in
            return  MinderRequestDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.getMindingRequests()
            }
          
        }.disposed(by: disposeBag)
        
        viewModel.onBookingsItemClicked.flatMap { requestId in
            return  MinderBookingDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.getMindingRequests()
            }
          
        }.disposed(by: disposeBag)
        
        
        bindAvailabilitySwitchChangeListener()
        bindMindingItems()
        bindRequestsItems()
        bindBookingsItems()
    }
    
    func bindAvailabilitySwitchChangeListener(){
        viewModel.availabilitySwitchChanged.bind { [self] it in
            viewModel.updateAvailabilityStatus(availableStatus: it)
        }.disposed(by: disposeBag)
       
        viewModel.minderAvailableStatus.bind{ it in
            let isAvailable = (it == .AVAILABLE)
            self.binding.availabilitySwitch.setOn(isAvailable, animated: true)
            self.binding.availabilitySwitch.thumbTintColor = isAvailable ? .primary : UIColor(hexString: "#B2B3B3")
            self.binding.availabilitySwitchContainer.backgroundColor = isAvailable ? .primary : UIColor(hexString: "#B2B3B3")
            self.binding.availabilityLabel.text = isAvailable ? "Available" : "Not Available"
           
        }.disposed(by: disposeBag)
    }
    
    private func bindMindingItems(){
        viewModel.activeMindingItems
            .bind(to: binding.activeMindingsCollection.rx.items(cellIdentifier: ActiveMindingItemCell.Identifier)){ [unowned self] (row, item, cell)  in
                let cell = cell as! ActiveMindingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onActiveMindingItemClicked.accept(item.id)
                }
                
            }.disposed(by: disposeBag)
        
        viewModel.activeMindingItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyActiveMindingListLabel.isHidden = viewModel.activeMindingItems.value.count != 0
                binding.activeMindingsCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.activeMindingsCollection.contentSize.height, 12))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindRequestsItems(){
        viewModel.requestItems
            .bind(to: binding.requestsCollection.rx.items(cellIdentifier: MindingRequestItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MindingRequestItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onRequestsItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
        
        viewModel.requestItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyRequestListLabel.isHidden = viewModel.requestItems.value.count != 0
                binding.requestsCollection.snp.updateConstraints{ make in
                    make.height.equalTo(
                        (viewModel.requestItems.value.count != 0) ?
                        180 : 12
                    )
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindBookingsItems(){
        viewModel.bookingItems
            .bind(to: binding.bookingsCollection.rx.items(cellIdentifier: BookingItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! BookingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onBookingsItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
        
        viewModel.bookingItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyBookingListLabel.isHidden = viewModel.bookingItems.value.count != 0
                binding.bookingsCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.bookingsCollection.contentSize.height, 12))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }
    
  
}
