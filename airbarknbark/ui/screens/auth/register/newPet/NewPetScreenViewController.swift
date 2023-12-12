//
//  NewPetScreenViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 14/09/2022.
//

import Foundation
import MaterialComponents.MaterialDialogs
import RxSwift
import RxRelay
import SDWebImage


class NewPetScreenViewController : ViewController<NewPetScreenView, NewPetViewModel>{
    
    var disableEdit = false
    
    override func setupView() {
        self.isModalInPresentation  = true
        
        if(disableEdit){
            binding.containerStack.isUserInteractionEnabled = false
            binding.backButton.isUserInteractionEnabled = true
            binding.continueButton.isHidden = true
        }
        binding.uploadPhotoView.rx.tapGesture()
            .when(.recognized)
            .map { it in }
            .bind(to: viewModel.newImageButtonClciked)
            .disposed(by: disposeBag)
        
        viewModel.newImageButtonClciked
            .flatMap { [self] it in
                pickImages(max: 5)
            }.map{[self] images in
                viewModel.images.value + images.map{ImageOrURL(image: $0, imageURL: nil)}
            }.bind(to: viewModel.images)
            .disposed(by: disposeBag)
        
        Observable.merge(
            binding.yesCheckBox.checkBox.rx.checkChanges.asObservable(),
            binding.noChecBox.checkBox.rx.checkChanges.asObservable().map { !$0 }
        )
        .bind(to: viewModel.immunizationStatus)
        .disposed(by: disposeBag)
        
        binding.breedField.rx.tapGesture()
            .when(.recognized)
            .flatMap{ [self]  _ in self.showBreedPicker() }
            .do(onNext: { it in
                print(it)
            })
                .bind(onNext: viewModel.breed.accept)
                .disposed(by: disposeBag)
                
                binding.backButton.rx.tap
                .bind(to: viewModel.dismissBy)
                .disposed(by: disposeBag)
                
                
                viewModel.immunizationStatus.bind { [self] isChecked in
                    binding.yesCheckBox.checkBox.isChecked = isChecked == true
                    binding.noChecBox.checkBox.isChecked = isChecked == false
                }.disposed(by: disposeBag)
        
        bind(field: binding.petNameField, relay: viewModel.name)
        
        binding.continueButton.rx.tap
            .map { it in }
            .bind(to: viewModel.doneButtonClick)
            .disposed(by: disposeBag)
        
        viewModel.fetchedAbout.bind{
            self.binding.aboutInputField.textView.text = $0
            self.binding.aboutInputField.textView.becomeFirstResponder()
            self.binding.aboutInputField.textView.resignFirstResponder()
        }.disposed(by: disposeBag)
        binding.aboutInputField.textView.rx.text.orEmpty.bind(to: viewModel.about).disposed(by: disposeBag)
        
        binding.breedField.inputView = UIView()
        
        viewModel.breed
            .map{ $0?.name }
            .bind(to: binding.breedField.rx.text)
            .disposed(by: disposeBag)
        
        binding.dateOfBirth
            .asPickerField()
            .bind(allItems: Observable.just(viewModel.allYears()), selected: viewModel.dateOfBirth, by: { it in
                it
            })
            .disposed(by: disposeBag)
        
        binding.behaviourField
            .asPickerField()
            .bind(allItems: viewModel.allBehaviours, selected: viewModel.behaviour){
                $0
            }.disposed(by: disposeBag)
        
        bindPetImages()
        viewModel.loadPetDetails()
        
        if(viewModel.pet != nil){
            self.binding.continueButton.setTitle("Update", for: .normal)
        }
    }
    
    func bindPetImages(){
        viewModel.images
            .map {
                $0.isEmpty
                ? []
                : $0.map { item in
                    ItemOrNew.Item(item)
                } + [ItemOrNew.New]
            }
            .bind(to: binding.petsCollectionView.rx.items(cellIdentifier: RemovableItemWithLabel.Identifier)){  [self] (row, item, cell)  in
                
                let cell = cell as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let image) :
                    if(image.image != nil){
                        cell.image.image = image.image
                    }else{
                        cell.image.loadImage(src: image.imageURL, type: .Pet )
                    }
                    
                    cell.label.isHidden = true
                    cell.image.layer.cornerRadius = 20
                    cell.image.clipsToBounds = true
                    cell.minusIcon.isHidden = false
                    
                    cell.minusIcon.rx.tapGesture().when(.recognized)
                        .map { it in
                            image
                        }.bind(to:viewModel.removeImageButtonClick)
                        .disposed(by: cell.disposeBag)
                    
                    break
                    
                case .New :
                    cell.image.image = UIImage(named: "ic_circle_outline_plus")
                    cell.label.text = "New Image"
                    cell.image.layer.cornerRadius = 0
                    cell.image.clipsToBounds = false
                    cell.label.isHidden = false
                    cell.minusIcon.isHidden = true
                    
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in }
                        .bind(to: viewModel.newImageButtonClciked)
                        .disposed(by: cell.disposeBag)
                    break
                }
            }.disposed(by: disposeBag)
        
        viewModel.images
            .map{  !$0.isEmpty  }
            .bind(to: binding.uploadPhotoView.rx.isHidden).disposed(by: disposeBag)
    }
    
    
    func result() -> Observable<PetDetails>{
        return viewModel.onNewPet.asObservable()
    }
    
}

