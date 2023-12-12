//
//  NotificationViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 18/11/2022.
//

import Foundation
import UIKit
import RxSwift

class NotificationsViewController : ViewController<NotificationsView,NotificationsViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    
    override func setupView() {
        SessionManager.shared.notificationBadgeCount = 0
        
        binding.backButton.addOnClickListner { [unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        bindNotificationItems()
        bindNavigation()
    }
    
    private func bindNotificationItems(){
        
        binding.notificationsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.notificationItems
            .bind(to: binding.notificationsTableView.rx.items(cellIdentifier: NotificationsItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! NotificationsItemCell
                cell.configure(model : item)
                
                cell.rx.tapGesture().when(.recognized)
                    .map { it in item }
                    .bind(to: viewModel.notificationClicked)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        viewModel.notificationItems
            .map{  !$0.isEmpty  }
            .bind(to: binding.emptyNotificationLabel.rx.isHidden).disposed(by: disposeBag)
        
        binding.markAllAsSeenView.rx.tapGesture().when(.recognized).bind{[weak self] _ in
            self?.viewModel.markAllAsSeen()
        }.disposed(by: disposeBag)
        
    }
    
    
    private func bindNavigation(){
        self.viewModel.navigateTo.bind{
            navigationType in
            switch(navigationType){
            case .MINDING_BY(let id):
                FindingForDetailsViewController().apply {it in
                    it.viewModel.requestId = id
                    it.parentController = self.parentController
                    self.navigationController?.pushViewController(it, animated: true)
                }.result().bind{
                    self.navigationController?.popViewController(animated: true)
                    self.viewModel.triggerHomeRefresh.accept(Void())
                }.disposed(by: self.disposeBag)
                
            case .MINDER_REQUEST(let id):
                MinderRequestDetailsViewController().apply { [self] it in
                    it.viewModel.requestId = id
                    self.navigationController?.pushViewController(it, animated: true)
                }.result().bind{
                    self.navigationController?.popViewController(animated: true)
                    self.viewModel.triggerHomeRefresh.accept(Void())
                }.disposed(by: self.disposeBag)
                
            case .MINDER_BOOKING(let id):
                MinderBookingDetailsViewController().apply { [self] it in
                    it.viewModel.requestId = id
                    self.navigationController?.pushViewController(it, animated: true)
                }.result().bind{
                    self.navigationController?.popViewController(animated: true)
                    self.viewModel.triggerHomeRefresh.accept(Void())
                }.disposed(by: self.disposeBag)
                
            case .MINDING_FOR(let id):
                MindingForDetailsViewController().apply { [self] it in
                    it.viewModel.requestId = id
                    it.parentController = self.parentController
                    self.navigationController?.pushViewController(it, animated: true)
                }.result().bind{
                    self.navigationController?.popViewController(animated: true)
                    self.viewModel.triggerHomeRefresh.accept(Void())
                }.disposed(by: self.disposeBag)
                
            case .FINDER_REQUEST(let id):
                FinderRequestDetailsViewController().apply { [self] it in
                    it.viewModel.requestId = id
                    self.navigationController?.pushViewController(it, animated: true)
                }.result().bind{
                    self.navigationController?.popViewController(animated: true)
                    self.viewModel.triggerHomeRefresh.accept(Void())
                }.disposed(by: self.disposeBag)
                
            case .FINDER_BOOKING(let id):
                FinderBookingDetailsViewController().apply { [self] it in
                    it.viewModel.requestId = id
                    it.parentController = self.parentController
                    self.navigationController?.pushViewController(it, animated: true)
                }.result().bind{
                    self.navigationController?.popViewController(animated: true)
                    self.viewModel.triggerHomeRefresh.accept(Void())
                }.disposed(by: self.disposeBag)
                
            case .NEW_REVIEW:
                YourReviewsViewController().apply { it in
                    self.navigationController?.pushViewController(it, animated: true)
                }
                
            case .CONVERSATION:
                self.navigationController?.pushViewController(FinderChatTabViewController() , animated: true)
                
            case .CHAT_MESSAGE(let chatId):
                ChatDetailsViewController().apply { it in
                    self.parentController?.navigationController?.pushViewController(it.forConversationId(conversationId: chatId), animated: true)
                }
               
            case .PROFILE_UPDATED:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.navigationController?.popViewController(animated: true)
                }
                self.parentController?.setSelctedItem(selectedIndex: 3)
                
            }
        }.disposed(by: disposeBag)
    }
    
    
    func result() -> Observable<Void>{
        return viewModel.triggerHomeRefresh.asObservable()
    }
}

extension NotificationsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            _,_,_  in
            self.viewModel.deleteNotification(notificationId : self.viewModel.notificationItems.value[indexPath.row].id)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
