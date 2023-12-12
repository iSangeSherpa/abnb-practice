//
//  HomeTabViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
import RxGesture

class FinderChatTabViewController : ViewController<FinderChatTabView, FinderChatTabViewModel>{
    
    var parentController:HomeContainerScreenViewController? = nil
    
    override func setupView() {
        bindConverstionItems()
    }
    
    private func bindConverstionItems(){
                
//        let datasource = RxCollectionViewSectionedAnimatedDataSource<SectionOf<ConversationWithLatestMessage>>(
//            animationConfiguration: AnimationConfiguration()) { [self] dataSource, collectionView, indexPath, item in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationItemCell.Identifier, for: indexPath) as! ConversationItemCell
//
//                cell.configure(item: item)
//
//                cell.addOnClickListner {
//                    self.parentController?.navigationController?.pushViewController(ChatDetailsViewController().forConversationId(conversationId: item.conversation.id), animated: true)
//                }
//
//                return cell
//            }
        
        viewModel.conversationItems.bind(to: binding.conversationTableView.rx.items(cellIdentifier: ConversationItemCell.Identifier)){  [self] (row, item, cell)  in
            let cell = cell as! ConversationItemCell
            cell.configure(item : item)
            
            cell.rx.tapGesture().when(.recognized)
                .bind{ [weak self] _ in
                    self?.parentController?.navigationController?.pushViewController(ChatDetailsViewController().forConversationId(conversationId: item.conversation.id), animated: true)
                }
                .disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        binding.conversationTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
//        viewModel.conversationItems.map{
//            [SectionOf(items: $0, id: String(describing: self))]
//        }.bind(to: binding.conversationCollection.rx.items(dataSource: datasource))
//            .disposed(by: disposeBag)
        
        viewModel.conversationItems.bind{ conversationItems in
//            SessionManager.shared.chatBadgeCount =  conversationItems.filter{!$0.conversation.isSeen}.count
        }.disposed(by: disposeBag)
      
        
        binding.refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: viewModel.refreshConversation)
            .disposed(by: disposeBag)
        
        viewModel.loading
            .bind(to: binding.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
                
        
    }
    
    override func handleLoadingUI(isLoading: Bool) {
        // override to prevent showing loading dialog
    }
}

extension FinderChatTabViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            _,_,_  in
            self.viewModel.deleteConversation(conversationId: self.viewModel.conversationItems.value[indexPath.row].conversation.id)
        }

        return nil //UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

