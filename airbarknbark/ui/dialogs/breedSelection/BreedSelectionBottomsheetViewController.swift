//
//  BreedSelectionViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 19/12/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class BreedSelectionBottomSheetViewController : DialogViewController<BreedSelectionBottomSheetView,BreedSelectionBottomSheetViewModel>{
    
    lazy var selects: Observable<Breed> = viewModel.onBreedSelected.asObservable()
    
    
    override func setupView() {
        super.setupView()
        
        
        viewModel.onBreedSelected
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        binding.searchField.rx.text.orEmpty
            .map{ $0.trimmingCharacters(in: .whitespaces) }
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
        
        binding.crossButton.addOnClickListner {[unowned self] () in
            self.dismiss(animated: true)
        }
        binding.addNewBreedLabel.rx.tapGesture().when(.recognized).bind{_ in
            self.addNewBreed()
        }.disposed(by: disposeBag)
        bindBreeds()
    }
    
    
    func handleBreedCellTap(item:ItemOrNew<Breed>){
        switch(item){
        case .New:
            addNewBreed()
            break;
        case .Item(let breed):
            viewModel.onBreedSelected.accept(breed)
            break
        }
    }
    
    func addNewBreed(){
        let alert = UIAlertController(title: "Add New Breed", message: "enter name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak alert] (_) in
            let textField = alert!.textFields![0]
            self?.viewModel.addBreed(name: textField.text!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func bindBreeds(){
        
        viewModel.searchResult
            .map {
                $0.map { item in
                    ItemOrNew.Item(item)
                }
            }
            .bind(to: binding.breedsCollectionView.rx.items(cellIdentifier: BreedCell.Identifier)){ [unowned self] (row, item, cell)  in
                
                let cell = cell as! BreedCell
                
                cell.bind(item: item)
                
                cell.rx.tapGesture().when(.recognized)
                    .map { it in item }
                    .bind(onNext: self.handleBreedCellTap(item:))
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
    }
    

    public override var preferredContentSize: CGSize {
        get {
            return .init(width: 600, height: 375)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
}

extension UIViewController {
    func showBreedPicker() -> Observable<Breed>{
        let vc = BreedSelectionBottomSheetViewController()
        self.present(vc, animated: true)
        return vc.selects
    }
}
