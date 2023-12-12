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
import RxDataSources

class NewDocumentScreenViewController : ViewController<NewDocumentScreenView, NewDocumentViewModel>{
    
    override func setupView() {
        self.isModalInPresentation  = true
        
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        binding.documentTypeField.asPickerField()
            .bind(allItems: viewModel.allDocumentTypes.map{$0},selected: viewModel.documentType){
                $0?.description
            }.disposed(by: disposeBag)
        
        bind(field: binding.idNumberField, relay: viewModel.idNumber)
        bind(field: binding.issuePlaceField, relay: viewModel.issuedPlace)
        
        binding.continueButton.rx.tap
            .map { it in }
            .bind(to: viewModel.doneButtonClick)
            .disposed(by: disposeBag)
        
        binding.uploadPhotoView.rx.tapGesture()
            .when(.recognized)
            .map { it in }
            .bind(to: viewModel.newImageButtonClicked)
            .disposed(by: disposeBag)
        
        viewModel.newImageButtonClicked
            .flatMap { [self] it in
                pickImages(max: 5)
            }.map{[self] images in
                viewModel.images.value + images.map{ImageOrURL(image: $0, imageURL: nil)}
            }.bind(to: viewModel.images)
            .disposed(by: disposeBag)
        
        bindImages()
        viewModel.loadDocumentDetails()
        
        if(viewModel.document != nil){
            self.binding.continueButton.setTitle("Update", for: .normal)
        }
    }
    
    func bindImages(){
        viewModel.images
            .map {
                $0.isEmpty
                ? []
                : ($0.map { item in
                    ItemOrNew.Item(item)
                } + [ItemOrNew.New])
            }
            .bind(to: binding.documentImageCollectionView.rx.items(cellIdentifier: RemovableItemWithLabel.Identifier)){  [self] (row, item, cell)  in
                
                let cell = cell as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let image) :
                    if(image.image != nil){
                        cell.image.image = image.image
                    }else{
                        cell.image.loadImage(src: image.imageURL, type: .Other )
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
                        .bind(to: viewModel.newImageButtonClicked)
                        .disposed(by: cell.disposeBag)
                    break
                }
            }.disposed(by: disposeBag)
        
        viewModel.images
            .map{  !$0.isEmpty  }
            .bind(to: binding.uploadPhotoView.rx.isHidden).disposed(by: disposeBag)
    }
    
    
    func result() -> Observable<DocumentDetails>{
        return viewModel.onNewDocument.asObservable()
    }
}

