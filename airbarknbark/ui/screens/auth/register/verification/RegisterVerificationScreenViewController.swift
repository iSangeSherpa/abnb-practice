//
//  NewPetScreenViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 14/09/2022.
//

import Foundation
import MaterialComponents.MaterialDialogs
import RxRelay
import RxDataSources
import SDWebImage

class RegisterVerificationScreenViewController : ViewController<RegisterVerificationScreenView, RegisterVerificationScreenViewModel>{
    
    override func setupView() {
        
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        viewModel.address.map {   $0?.name }
            .bind(to: binding.addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        binding.dateOfBirth
            .asDatePickerField()
            .bind(selected: viewModel.dateOfBirth){ it in
                it?.asDateString()
            }.disposed(by: disposeBag)
        
        viewModel.newDocumentClicked.flatMap { it in
            return  NewDocumentScreenViewController().apply { [self] it in
                self.present(it, animated: true)
            }.result()
            
        }
        .bind { [self] it in
            self.viewModel.documents.accept(viewModel.documents.value + [it])
        }.disposed(by: disposeBag)
        
        binding.newDocumentView.rx.tapGesture().when(.recognized)
            .map { it in }
            .bind(to: viewModel.newDocumentClicked)
            .disposed(by: disposeBag)
        
        binding.termsCheckBox.rx.checkChanges
            .map {
                !$0
            }.bind(to: viewModel.hasPasCriminalActivity)
            .disposed(by: disposeBag)
        
        viewModel.hasPasCriminalActivity
            .map {  !$0  }
            .bind(to: binding.termsCheckBox.rx.isChecked)
            .disposed(by: disposeBag)
        
        binding.travellingInfoStack.rx.tapGesture().when(.recognized)
            .flatMap{ it in
                NewVehicleScreenViewController().apply { [self] it in
                    self.present(it, animated: true)
                    guard let vehicle = self.viewModel.vehicle.value else {return}
                    it.viewModel.loadVehicleInfo(vehicle: vehicle)
                }.result()
            }
            .bind(to: viewModel.vehicle)
            .disposed(by: disposeBag)
        
        binding.continueButton.rx.tap
            .bind { [unowned self] in
                viewModel.updateVerificationDetail()
            }.disposed(by: disposeBag)
        
        viewModel.vehicle.bind { [unowned self] it in
            let vehicleAdded = it != nil
            binding.travellingInfoIcon.image = vehicleAdded ? UIImage(named: "ic_circle_check") : UIImage(named: "ic_plus")
            binding.travellingInfoStack.spacing = vehicleAdded ? 4 : 0
            binding.travellingInfoText.text = vehicleAdded ? "Vehicle details has been added. Click to view." : "I am a traveller"
            binding.travellingInfoText.textColor = vehicleAdded ? .primary : .onBackground
        }.disposed(by: disposeBag)
        
        binding.addressFieldPressable.rx.tapGesture().when(.recognized)
            .flatMap{ it in
                AddressPickerViewController().apply { [self] it in
                    self.present(it, animated: true)
                }.result()
            }
            .bind{ [self] addressDetail in
                self.viewModel.updateAddress(addressDetail: addressDetail)
            }
            .disposed(by: disposeBag)
        
        binding.addressDeleteView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] (_) in
            self?.viewModel.removeAddress()
        }).disposed(by: disposeBag)
       
        binding.emailAddressField.isUserInteractionEnabled = false
        binding.emailAddressField.text = SessionManager.shared.email
        
        bind(field: binding.contactNumber, relay: viewModel.contactNumber)
        bind(field: binding.emergencyContact, relay: viewModel.emergencyContactNumber)
        binding.showMyNumberCheckbox.rx.checkChanges.bind(to:viewModel.showMyNumber).disposed(by: disposeBag)
        viewModel.showMyNumber.bind(to: binding.showMyNumberCheckbox.rx.isChecked).disposed(by: disposeBag)
        binding.showMyNumberContainer.addOnClickListner {[unowned self] in
            self.viewModel.showMyNumber.accept(!self.viewModel.showMyNumber.value)
        }
        
        bindDocumuments()
        
        viewModel.onUpdateUserVerificationForm.bind{
            [self] _ in
            
            if(SessionManager.shared.userType == .FINDER){
                PopupDialogView.showPopupDialog(
                    vc: self,
                    title: .Dialog.sentForVerificationTitle,
                    body: .Dialog.sentForVerificationBody,
                    buttonText : .Dialog.gotoHome
                ).subscribe(onSuccess: {
                    self.navigationController?.pushViewController(HomeContainerScreenViewController(), animated: true)
                },onCompleted: {
                    self.navigationController?.pushViewController(HomeContainerScreenViewController(), animated: true)
                }).disposed(by: disposeBag)
            }else{
                navigationController?.pushViewController(MinderProfileSetupScreenViewController().apply({ it in
                    it.viewModel.forIncompleteProfile = self.viewModel.forIncompleteProfile
                    it.viewModel.isTravelling = (viewModel.vehicle.value != nil)
                }), animated: true)
            }
        }.disposed(by: disposeBag)
        
        
        binding.isTravellingInfoImageView.addOnClickListner{[unowned self] in
            self.alert(alertText: "Traveller", alertMessage: .RegisterVerification.isTravellingInfoText)
        }
//        binding.travellingInfoStack.isHidden = SessionManager.shared.userType == .FINDER
//        binding.isTravellingInfoImageView.isHidden = SessionManager.shared.userType == .FINDER
//
        
        if(viewModel.forIncompleteProfile){
            viewModel.loadData()
        }
        
        viewModel.documentClicked.flatMap{ doc in
            return  NewDocumentScreenViewController().apply { [self] it in
                it.viewModel.document = doc
                self.present(it, animated: true)
            }.result()
        }.bind{ [self] it in
            
            if(self.viewModel.documents.value.filter{$0.id == it.id}.count == 0){
                self.viewModel.documents.accept(viewModel.documents.value + [it])
            }else{
                var docs =  self.viewModel.documents.value
                for i in 0...docs.count-1{
                    if(docs[i].id == it.id){
                        docs[i] = it
                        self.viewModel.documents.accept(docs)
                        break
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    
    func bindDocumuments(){
        
        let datasource = RxCollectionViewSectionedAnimatedDataSource<SectionOf<ItemOrNew<DocumentDetails>>>(
            animationConfiguration: AnimationConfiguration()) { [self] dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovableItemWithLabel.Identifier, for: indexPath) as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let document) :
                    cell.image.loadImage(src: document.files?.first)
                    cell.label.text = document.type.rawValue
                    cell.image.layer.cornerRadius = 20
                    cell.image.clipsToBounds = true
                    cell.minusIcon.isHidden = false
                    cell.minusIcon.rx.tapGesture().when(.recognized)
                        .map { it in
                            document.id
                        }.bind(to:viewModel.removeDocumentClicked)
                        .disposed(by: cell.disposeBag)
                    
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in
                            document
                        }
                        .bind(to: viewModel.documentClicked)
                        .disposed(by: cell.disposeBag)
                    break
                    
                case .New :
                    cell.image.image = UIImage(named: "ic_circle_outline_plus")
                    cell.label.text = "New Document"
                    cell.image.layer.cornerRadius = 0
                    cell.image.clipsToBounds = false
                    cell.minusIcon.isHidden = true
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in }
                        .bind(to: viewModel.newDocumentClicked)
                        .disposed(by: cell.disposeBag)
                    break
                }
                
                return cell
            }
        
        viewModel.documents.map {
            $0.isEmpty ?
            [] :
            $0.map { item in
                ItemOrNew.Item(item)
            } + [ItemOrNew.New]
            
        }.map{
            [SectionOf(items: $0)]
        }
        .bind(to: binding.documentsCollectionView.rx.items(dataSource: datasource))
        .disposed(by: disposeBag)
        
        viewModel.documents.map { !$0.isEmpty }
            .bind(to: binding.newDocumentView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.address.map { address in
            let lat = String(format: "%.2f", address?.lat ?? "")
            let long = String(format: "%.2f", address?.lang ?? "")
            let name = address?.name ?? ""
            if name.isEmpty && lat=="0.00" && long=="0.00"{
                return ""
            }
                
            return "\(name), (\(lat),\(long))"
        }.bind(to: binding.addressLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}

