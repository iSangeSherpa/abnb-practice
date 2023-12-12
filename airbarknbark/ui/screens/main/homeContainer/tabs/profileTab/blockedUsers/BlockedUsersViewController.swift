//
//  BlockedUsersViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/02/2023.
//

import Foundation


class BlockedUsersViewController : ViewController<BlockedUsersView,BlockedUsersViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    
    override func setupView() {
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        bindBlockedUsers()
        
        binding.refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: {
                self.binding.refreshControl.endRefreshing()
                self.viewModel.getBlockedUsers()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindBlockedUsers(){
        viewModel.blockedUsersList
            .bind(to: binding.blockedUsersCollection.rx.items(cellIdentifier: BlockedUsersItemCell.Identifier)){ [self] (row, item, cell)  in
                let cell = cell as! BlockedUsersItemCell
                cell.configure(model:item)
                cell.unblockButton.rx.tapGesture().when(.recognized).bind{ _ in
                    BlockUnblockAccountDialog.showBlockUnblockAccountDialog(vc: self, message: .Dialog.unblockAccountMessage,buttonText: .Dialog.unblockAccountButtonText)
                        .subscribe(onSuccess: { _ in
                            self.viewModel.unblockUser(userId: item.id)
                        }).disposed(by: self.disposeBag)
                }.disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
    }
}
