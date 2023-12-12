//
//  YourDocumentsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 16/11/2022.
//

import Foundation
import UIKit

class YourDocumentsViewController : ViewController<YourDocumentsView,YourDocumentsViewModel>{
    
    override func setupView() {
        binding.saveButton.isHidden = true
        
        binding.backButton.addOnClickListner {[unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        binding.saveButton.addOnClickListner { [unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        
        binding.addNewLabel.rx.tapGesture().skip(1).flatMap { it in
            return  NewDocumentScreenViewController().apply { [self] it in
                self.present(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            self.viewModel.allDocuments.accept(viewModel.allDocuments.value + [it])
        }.disposed(by: disposeBag)
        
        
        viewModel.documentClicked.flatMap{ doc in
            return  NewDocumentScreenViewController().apply { [self] it in
                it.viewModel.document = doc
                self.present(it, animated: true)
            }.result()
        }.bind{ [self] it in
            
            if(self.viewModel.allDocuments.value.filter{$0.id == it.id}.count == 0){
                self.viewModel.allDocuments.accept(viewModel.allDocuments.value + [it])
            }else{
                var docs =  self.viewModel.allDocuments.value
                for i in 0...docs.count-1{
                    if(docs[i].id == it.id){
                        docs[i] = it
                        self.viewModel.allDocuments.accept(docs)
                        break
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.getDocuments()
        
        bindYourDocuments()
    }
    
    func bindYourDocuments(){
        viewModel.allDocuments.bind(to: binding.yourDocumentsTableView.rx.items(cellIdentifier: DocumentsTableViewCell.Identifier)){  [self] (row, item, cell)  in
            let cell = cell as! DocumentsTableViewCell
            cell.configure(model : item)
            
            cell.topSection.rx.tapGesture().when(.recognized)
                .map { it in item }
                .bind(to: viewModel.documentClicked)
                .disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        binding.yourDocumentsTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension YourDocumentsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            _,_,_  in
            self.viewModel.removeDocument(documentId: self.viewModel.allDocuments.value[indexPath.row].id)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
