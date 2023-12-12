//
//  BothHomeTabViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/01/2023.
//

import Foundation
import UIKit
import RxSwift

class BothHomeTabViewController : ViewController<BothHomeTabView,BothHomeTabViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    override func setupView() {
        binding.refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: {
                self.binding.refreshControl.endRefreshing()
                self.viewModel.getBothRequests()
                self.viewModel.refreshNotifications()
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
                    self.viewModel.getBothRequests()
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
            if(self.binding.requestsToggleView.forBy == .FOR){
                self.viewModel.onSeeAllForRequestsClicked.accept(Void())
            }else{
                self.viewModel.onSeeAllByRequestsClicked.accept(Void())
            }
        }
    
        viewModel.onSeeAllForRequestsClicked.flatMap { requestId in
            return  FinderAllRequestsViewController().apply { [self] it in
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getBothRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onSeeAllByRequestsClicked.flatMap { requestId in
            return  MinderAllRequestsViewController().apply { [self] it in
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getBothRequests()
        }.disposed(by: disposeBag)
        
        //When Bookings's see all button clicked
        binding.viewAllBookingsButton.addOnClickListner { [unowned self] in
            if(self.binding.bookingsToggleView.forBy == .FOR){
                self.viewModel.onSeeAllForBookingsClicked.accept(Void())
            }else{
                self.viewModel.onSeeAllByBookingsClicked.accept(Void())
            }
        }
        
        viewModel.onSeeAllForBookingsClicked.flatMap { requestId in
            return  FinderAllBookingsViewController().apply { [self] it in
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getBothRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onSeeAllByBookingsClicked.flatMap { requestId in
            return  MinderAllBookingsViewController().apply { [self] it in
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getBothRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onActiveMindingsForItemClicked.flatMap { requestId in
            return  MindingForDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getBothRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onActiveMindingsByItemClicked.flatMap { requestId in
            return  FindingForDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            viewModel.getBothRequests()
        }.disposed(by: disposeBag)
        
        viewModel.onRequestsForItemClicked.flatMap { requestId in
            return  FinderRequestDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.getBothRequests()
            }
        }.disposed(by: disposeBag)
        
        viewModel.onRequestsByItemClicked.flatMap { requestId in
            return  MinderRequestDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.getBothRequests()
            }
        }.disposed(by: disposeBag)
        
        viewModel.onBookingsForItemClicked.flatMap { requestId in
            return  FinderBookingDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.getBothRequests()
            }
        }.disposed(by: disposeBag)
        
        viewModel.onBookingsByItemClicked.flatMap { requestId in
            return  MinderBookingDetailsViewController().apply { [self] it in
                it.viewModel.requestId = requestId
                it.parentController = self.parentController
                self.parentController?.navigationController?.pushViewController(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.getBothRequests()
            }
        }.disposed(by: disposeBag)
        
        
        binding.activeMindingToggleView.addOnValueChangeListener{
            self.viewModel.activeMindingsActiveTab.accept($0)
        }
        binding.requestsToggleView.addOnValueChangeListener{
            self.viewModel.requestsActiveTab.accept($0)
        }
        binding.bookingsToggleView.addOnValueChangeListener{
            self.viewModel.bookingsActiveTab.accept($0)
        }
        
        
        viewModel.activeMindingsActiveTab.bind{ activeTab in
            if(activeTab == .FOR){
                self.binding.emptyActiveMindingListLabel.isHidden = !self.viewModel.activeMindingForItems.value.isEmpty
            }
            else{
                self.binding.emptyActiveMindingListLabel.isHidden = !self.viewModel.activeMindingByItems.value.isEmpty
            }
            self.updateForByView(
                currentItem: activeTab,
                forView: self.binding.activeMindingsForCollection,
                byView: self.binding.activeMindingsByCollection
            )
            
        }.disposed(by: disposeBag)
        
        viewModel.requestsActiveTab.bind{ activeTab in
            if(activeTab == .FOR){
                self.binding.emptyRequestListLabel.isHidden = !self.viewModel.requestForItems.value.isEmpty
            }else{
                self.binding.emptyRequestListLabel.isHidden = !self.viewModel.requestByItems.value.isEmpty
            }
            self.updateForByView(
                currentItem: activeTab,
                forView: self.binding.requestsForCollection,
                byView: self.binding.requestsByCollection
            )
            
        }.disposed(by: disposeBag)
        
        viewModel.bookingsActiveTab.bind{  activeTab in
            if(activeTab == .FOR){
                self.binding.emptyBookingListLabel.isHidden = !self.viewModel.bookingForItems.value.isEmpty
            }else{
                self.binding.emptyBookingListLabel.isHidden = !self.viewModel.bookingByItems.value.isEmpty
            }
            self.updateForByView(
                currentItem: activeTab,
                forView: self.binding.bookingsForCollection,
                byView: self.binding.bookingsByCollection
            )
        }.disposed(by: disposeBag)
        
        
        bindAvailabilitySwitchChangeListener()
        bindMindingItems()
        bindRequestsItems()
        bindBookingsItems()
    }
    
    func updateForByView(currentItem:ForByToggleView.ForBy, forView:UIView, byView:UIView){
        
        UIView.transition(with: binding, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            byView.isHidden = currentItem != .BY
            byView.alpha = currentItem == .BY ? 1.0 : 0.0
            forView.isHidden = currentItem != .FOR
            forView.alpha = currentItem == .FOR ? 1.0 : 0.0
        })
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
        viewModel.activeMindingForItems
            .bind(to: binding.activeMindingsForCollection.rx.items(cellIdentifier: ActiveMindingItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! ActiveMindingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onActiveMindingsForItemClicked.accept(item.id)
                }
                
            }.disposed(by: disposeBag)
        
        viewModel.activeMindingForItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                if(binding.activeMindingToggleView.forBy == .FOR){
                    binding.emptyActiveMindingListLabel.isHidden = !viewModel.activeMindingForItems.value.isEmpty
                }
                binding.activeMindingsForCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.activeMindingsForCollection.contentSize.height, 12))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        viewModel.activeMindingByItems
            .bind(to: binding.activeMindingsByCollection.rx.items(cellIdentifier: ActiveMindingItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! ActiveMindingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onActiveMindingsByItemClicked.accept(item.id)
                }
                
            }.disposed(by: disposeBag)
        
        viewModel.activeMindingByItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                if(binding.activeMindingToggleView.forBy == .BY){
                    binding.emptyActiveMindingListLabel.isHidden = !viewModel.activeMindingByItems.value.isEmpty
                }
                binding.activeMindingsByCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.activeMindingsByCollection.contentSize.height, 12))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindRequestsItems(){
        viewModel.requestForItems
            .bind(to: binding.requestsForCollection.rx.items(cellIdentifier: MindingRequestItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MindingRequestItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onRequestsForItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
        
        viewModel.requestForItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                if(binding.requestsToggleView.forBy == .FOR){
                    binding.emptyRequestListLabel.isHidden = !viewModel.requestForItems.value.isEmpty
                }
                binding.requestsForCollection.snp.updateConstraints{ make in
                    make.height.equalTo(
                        (viewModel.requestForItems.value.count != 0) ?
                        180 : 12
                    )
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        viewModel.requestByItems
            .bind(to: binding.requestsByCollection.rx.items(cellIdentifier: MindingRequestItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MindingRequestItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onRequestsByItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
        
        viewModel.requestByItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                if(binding.requestsToggleView.forBy == .BY){
                    binding.emptyRequestListLabel.isHidden = !viewModel.requestByItems.value.isEmpty
                }
                binding.requestsByCollection.snp.updateConstraints{ make in
                    make.height.equalTo(
                        (viewModel.requestByItems.value.count != 0) ?
                        180 : 12
                    )
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        viewModel.requestForItems.bind{ requests in
            self.binding.requestsToggleView.updateForTitleAppendingText(requests.count == 0 ? "":" (\(requests.count))")}.disposed(by: disposeBag)
        
        viewModel.requestByItems.bind{ requests in
                self.binding.requestsToggleView.updateByTitleAppendingText(requests.count == 0 ? "":" (\(requests.count))")}.disposed(by: disposeBag)
        
        
    }
    
    private func bindBookingsItems(){
        viewModel.bookingForItems
            .bind(to: binding.bookingsForCollection.rx.items(cellIdentifier: BookingItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! BookingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onBookingsForItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
        
        viewModel.bookingForItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                if(binding.bookingsToggleView.forBy == .FOR){
                    binding.emptyBookingListLabel.isHidden = !viewModel.bookingForItems.value.isEmpty
                }
                binding.bookingsForCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.bookingsForCollection.contentSize.height, 12))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        viewModel.bookingByItems
            .bind(to: binding.bookingsByCollection.rx.items(cellIdentifier: BookingItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! BookingItemCell
                cell.configure(model:item)
                cell.addOnClickListner { [unowned self] in
                    self.viewModel.onBookingsByItemClicked.accept(item.id)
                }
            }.disposed(by: disposeBag)
        
        viewModel.bookingByItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                if(binding.bookingsToggleView.forBy == .BY){
                    binding.emptyBookingListLabel.isHidden = !viewModel.bookingByItems.value.isEmpty
                }
                binding.bookingsByCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.bookingsByCollection.contentSize.height, 12))
                }
                binding.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        
        viewModel.bookingForItems.bind{ requests in
            self.binding.bookingsToggleView.updateForTitleAppendingText(requests.count == 0 ? "":" (\(requests.count))")}.disposed(by: disposeBag)
        
        viewModel.bookingByItems.bind{ requests in
                self.binding.bookingsToggleView.updateByTitleAppendingText(requests.count == 0 ? "":" (\(requests.count))")}.disposed(by: disposeBag)
    }
    
  
}
