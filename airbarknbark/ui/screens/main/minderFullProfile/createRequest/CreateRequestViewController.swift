//
//  CreateRequestViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 15/11/2022.
//

import Foundation
import UIKit
import MaterialComponents.MaterialDialogs
import RxSwift
import RxRelay


class CreateRequestViewController : ViewController<CreateRequestView, CreateRequestViewModel>{
    override func setupView() {
        self.isModalInPresentation  = true
        
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
    
        binding.fromDateValue
            .asDatePickerField(configBy: { picker in
                picker.pickerView.minimumDate = .now + 5 * 60
                picker.pickerView.datePickerMode  = .dateAndTime
            })
            .bind(selected: viewModel.fromDate){[self] it in
                self.viewModel.fromTime.accept(it?.format(dateFormat: "HH:mm a") ?? "")
                return it?.asDateString()
            }.disposed(by: disposeBag)
  
        binding.toDateValue
            .asDatePickerField(configBy: { picker in
                picker.pickerView.minimumDate = .now + 10 * 60
                picker.pickerView.datePickerMode  = .dateAndTime
            })
            .bind(selected: viewModel.toDate){[self] it in
                
                self.viewModel.toTime.accept(it?.format(dateFormat: "HH:mm a") ?? "")
                return it?.asDateString()
            }.disposed(by: disposeBag)
    
        binding.fromTimeValue
            .asDatePickerField(configBy: { picker in
                picker.pickerView.minimumDate = .now + 5 * 60
                picker.pickerView.datePickerMode  = .dateAndTime
            })
            .bind(selected: viewModel.fromDate){it in
                return (it?.format(dateFormat: "HH:mm a") ?? "")
            }.disposed(by: disposeBag)
        
        binding.toTimeValue
            .asDatePickerField(configBy: { picker in
                picker.pickerView.minimumDate = .now + 10 * 60
                picker.pickerView.datePickerMode  = .dateAndTime
            })
            .bind(selected: viewModel.toDate){ it in
                return (it?.format(dateFormat: "HH:mm a") ?? "")
            }.disposed(by: disposeBag)
               
        viewModel.fromTime.bind(to: binding.fromTimeValue.rx.text).disposed(by: disposeBag)
        viewModel.toTime.bind(to: binding.toTimeValue.rx.text).disposed(by: disposeBag)
        
        bind(field: binding.perHourRateInputField, relay: viewModel.perHourRate)
        bind(field: binding.additionalNotesInputField , relay: viewModel.message)
        
        binding.sendRequestButton.addOnClickListner { [unowned self] in
            self.viewModel.createRequest()
        }
        
        viewModel.onRequestSuccess.bind{ [self] in
            self.showSuccessDialog().subscribe(onSuccess: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.viewModel.dismissBy.accept(Void())
                }
            }).disposed(by: disposeBag)
        }.disposed(by: disposeBag)
        
        bindPetItems()
    }

    func bindPetItems(){
        viewModel.petItems
            .bind(to: binding.petsCollection.rx.items(cellIdentifier: SelectedPetItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! SelectedPetItemCell
                cell.configure(model: item)
                cell.rx.tapGesture().when(.recognized)
                    .map { it in item }
                    .bind(to: viewModel.petClicked)
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
         
    }
    
    func showSuccessDialog() -> Maybe<String>{
            return [.create{ [self] maybe in
                let viewController = DialogViewController<SuccessDialogView,ViewModel>().setupBy { dialog in
                    dialog.binding.thankYouButton.addOnClickListner {
                        maybe(.success(""))
                    }
                }
                present(viewController, animated: true)
                return Disposables.create {
                    viewController.dismiss(animated: true)
                }
            }][0]
    }
    
    func result() -> Observable<Void>{
        return viewModel.onRequestSuccess.asObservable()
    }
    
}

