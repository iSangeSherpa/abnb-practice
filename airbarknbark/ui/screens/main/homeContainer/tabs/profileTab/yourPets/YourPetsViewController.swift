//
//  YourPetsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 16/11/2022.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import RxRelay

class YourPetsViewController : ViewController<YourPetsView,YourPetsViewModel>{
   
    override func setupView() {
        binding.saveButton.isHidden = true
        
        binding.backButton.addOnClickListner { [unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        binding.saveButton.addOnClickListner { [unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        
        binding.addNewLabel.rx.tapGesture().skip(1).flatMap { it in
            return  NewPetScreenViewController().apply { [unowned self] it in
                self.present(it, animated: true)
            }.result()
        }
        .bind { [unowned self] it in
            self.viewModel.yourPetsItems.accept(viewModel.yourPetsItems.value + [it])
        }.disposed(by: disposeBag)
        
        
        viewModel.petClicked.flatMap{ pet in
            return  NewPetScreenViewController().apply { [unowned self] it in
                it.viewModel.pet = pet
                self.present(it, animated: true)
            }.result()
        }.bind{ [unowned self] it in
            if(self.viewModel.yourPetsItems.value.filter{$0.id == it.id}.count == 0){
                self.viewModel.yourPetsItems.accept(viewModel.yourPetsItems.value + [it])
            }else{
                var petItems =  self.viewModel.yourPetsItems.value
                for i in 0...petItems.count-1{
                    if(petItems[i].id == it.id){
                        petItems[i] = it
                        self.viewModel.yourPetsItems.accept(petItems)
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.getAllPets()
        
        bindYourPetsItems()
    }
    
    func bindYourPetsItems(){
        viewModel.yourPetsItems.bind(to: binding.yourPetsTableView.rx.items(cellIdentifier: YourPetsItemTableViewCell.Identifier)){  [self] (row, petDetailsItem, cell)  in
            let cell = cell as! YourPetsItemTableViewCell
            cell.configure(model : petDetailsItem)
            
            cell.topSection.rx.tapGesture().when(.recognized)
                .map { it in petDetailsItem }
                .bind(to: viewModel.petClicked)
                .disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        binding.yourPetsTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension YourPetsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            _,_,_  in
            self.viewModel.removePet(petId: self.viewModel.yourPetsItems.value[indexPath.row].id)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
