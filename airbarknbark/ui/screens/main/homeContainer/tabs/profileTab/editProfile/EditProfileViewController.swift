//
//  EditProfileViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 17/11/2022.
//

import Foundation
import UIKit
import RxRelay
import RxDataSources
import RxSwift
import RxCocoa
import SDWebImage

class EditProfileViewController : ViewController<EditProfileView, EditProfileViewModel>{
    
    
    override func setupView() {
        //MARK: - Hidden for now
        binding.availableDaysContainer.isHidden = true
        binding.workingHoursContainer.isHidden = true
        
        binding.backButton.rx.tap.bind(to:viewModel.dismissBy).disposed(by: disposeBag)
        
        binding.userProfileImage.rx.tapGesture().when(.recognized)
            .flatMap { [self] it in
                pickImages(max:1)
            }.map{
                $0.first
            }
            .filter { $0 != nil }
            .bind(to: viewModel.newProfileImage).disposed(by: disposeBag)
        
        
        viewModel.userImage.bind{
            self.binding.userProfileImage.loadImage(src: $0, type: .User)
        }.disposed(by: disposeBag)
        
        viewModel.newProfileImage.bind(to: binding.userProfileImage.rx.image).disposed(by: disposeBag)
        
        bind(field: binding.fullNameInputField, relay: viewModel.fullName)
        viewModel.fetchedShortBio.bind{
            self.binding.bioInputField.textView.text = $0
            self.binding.bioInputField.textView.becomeFirstResponder()
            self.binding.bioInputField.textView.resignFirstResponder()
        }.disposed(by: disposeBag)
        binding.bioInputField.textView.rx.text.orEmpty.bind(to: viewModel.shortBio).disposed(by: disposeBag)
        
        viewModel.newPetButtonClciked.flatMap { it in
            return  NewPetScreenViewController().apply { [self] it in
                self.present(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            self.viewModel.pets.accept(viewModel.pets.value + [it])
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
        
        viewModel.address.map{"\($0?.name ?? "" )"}.bind(to: binding.addressLabel.rx.text).disposed(by: disposeBag)
        
        binding.dateOfBirth
            .asDatePickerField()
            .bind(selected: viewModel.dateOfBirth){ it in
                it?.asDateString()
            }.disposed(by: disposeBag)
        
        bind(field: binding.contactNumber, relay: viewModel.contactNumber)
        bind(field: binding.emergencyContact, relay: viewModel.emergencyContact)
        
        binding.showMyNumberCheckbox.rx.checkChanges.bind(to:viewModel.showMyNumber).disposed(by: disposeBag)
        viewModel.showMyNumber.bind(to: binding.showMyNumberCheckbox.rx.isChecked).disposed(by: disposeBag)
        binding.showMyNumberContainer.addOnClickListner { [unowned self] in
            self.viewModel.showMyNumber.accept(!self.viewModel.showMyNumber.value)
        }
        binding.saveChangesButton.addOnClickListner { [unowned self] in
            self.viewModel.saveChanges()
        }
        
        Observable.merge(
            binding.maleCheckBox.checkBox.rx.checkChanges.map{ it in Gender.MALE },
            binding.femaleCheckBox.checkBox.rx.checkChanges.map{ it in Gender.FEMALE },
            binding.genderOtherCheckBox.checkBox.rx.checkChanges.map{ it in Gender.OTHER }
        ).bind(to: viewModel.gender)
            .disposed(by: disposeBag)
        
    
        viewModel.gender
            .bind(onNext: { [weak self] it in
                self?.binding.maleCheckBox.checkBox.isChecked = it == Gender.MALE
                self?.binding.femaleCheckBox.checkBox.isChecked = it == Gender.FEMALE
                self?.binding.genderOtherCheckBox.checkBox.isChecked = it == Gender.OTHER
            })
            .disposed(by: disposeBag)
        
        bindPets()
        
        if(SessionManager.shared.userType == .FINDER){
            binding.minderProfileViewStack.isHidden = true
            binding.dateOfBirth.label.text = .RegisterVerification.dateOfBirthOptional
            binding.contactNumber.label.text = .RegisterVerification.contactNumberOptional
            binding.emergencyContact.label.text = .RegisterVerification.emergencyContactNumberOptional
            return
        }
        
        //Minder Profile section starts from here
        Observable.merge(
            binding.availableYesCheckBox.checkBox.rx.checkChanges.asObservable(),
            binding.availableNoChecBox.checkBox.rx.checkChanges.asObservable().map { !$0 }
        )
        .bind(to: viewModel.available)
        .disposed(by: disposeBag)
        
        viewModel.available.bind { [self] isChecked in
            binding.availableYesCheckBox.checkBox.isChecked = isChecked == true
            binding.availableNoChecBox.checkBox.isChecked = isChecked == false
        }.disposed(by: disposeBag)
        
        
        Observable.merge(
            binding.travelingYesCheckBox.checkBox.rx.checkChanges.asObservable(),
            binding.travelingNoCheckBox.checkBox.rx.checkChanges.asObservable().map { !$0 }
        ).bind(to: viewModel.traveling).disposed(by: disposeBag)
        
        viewModel.traveling.bind { [self] isChecked in
            binding.travelingYesCheckBox.checkBox.isChecked = isChecked == true
            binding.travelingNoCheckBox.checkBox.isChecked = isChecked == false
        }.disposed(by: disposeBag)
        
        bindVehicles()
        
        bind(field: binding.rateField, relay: viewModel.rate)
        bind(field: binding.yearsOfExperienceField, relay: viewModel.yearsOfExpereince)
        
        viewModel.yearsOfExpereince
            .skip(1)
            .map { $0 == ""  }
            .startWith(false)
            .bind(to: binding.noExperienceCheckbox.rx.isChecked)
            .disposed(by: disposeBag)
        
        binding.noExperienceCheckbox.rx.checkChanges
            .map { it in
                ""
            }.bind(to: viewModel.yearsOfExpereince)
            .disposed(by: disposeBag)
        
     
        binding.preferenceSmall.rx.tapGesture().when(.recognized).map { it in PetSizePreferences.SMALL}.bind{
            self.viewModel.updatePetSize(petSize: $0)
        }.disposed(by: disposeBag)
        
        binding.preferenceMedium.rx.tapGesture().when(.recognized).map { it in PetSizePreferences.MEDIUM}.bind{
            self.viewModel.updatePetSize(petSize: $0)
        }.disposed(by: disposeBag)
        
        binding.preferenceLarge.rx.tapGesture().when(.recognized).map { it in PetSizePreferences.LARGE}.bind{
            self.viewModel.updatePetSize(petSize: $0)
        }.disposed(by: disposeBag)
        
        viewModel.dogSizePreference.bind { [unowned self] preference in
            (binding.preferenceSmall.subviews[0] as? CheckBox)?.isChecked = preference.contains(.SMALL)
            (binding.preferenceMedium.subviews[0] as? CheckBox)?.isChecked = preference.contains(.MEDIUM)
            (binding.preferenceLarge.subviews[0] as? CheckBox)?.isChecked = preference.contains(.LARGE)
        }.disposed(by: disposeBag)
        
       
        binding.breedPreferenceField.inputView = UIView()
        
        binding.breedPreferenceField.rx.tapGesture()
            .when(.recognized)
            .flatMap{ [self]  _ in self.showBreedPicker() }
            .bind(onNext: viewModel.selectedBreed.accept)
            .disposed(by: disposeBag)
        
        viewModel.selectedBreed
            .map{ $0?.name }
            .bind(to: binding.breedPreferenceField.rx.text)
            .disposed(by: disposeBag)
        
        
        binding.yearsOfExperienceField.leadingView!.rx.tapGesture().when(.recognized)
            .withLatestFrom(viewModel.yearsOfExpereince){ _, prev in
                max(0,(Float(prev ) ?? 0) - 0.5 )
            }
            .map { "\($0)" }
            .bind(to: viewModel.yearsOfExpereince)
            .disposed(by: disposeBag)
        
        binding.yearsOfExperienceField.trailingView!.rx.tapGesture().when(.recognized)
            .withLatestFrom(viewModel.yearsOfExpereince){ _, prev in
                (Float(prev ) ?? 0) + 0.5
            }
            .map { "\($0)" }
            .bind(to: viewModel.yearsOfExpereince)
            .disposed(by: disposeBag)
        
        bindAvailableDays()

    }
    
    func bindVehicles(){
        
        binding.newVehicleView.rx.tapGesture().when(.recognized).flatMap { it in
            NewVehicleScreenViewController().apply { [self] it in
                self.present(it, animated: true)
//                guard let vehicle = self.viewModel.vehicle.value else {return}
//                it.viewModel.loadVehicleInfo(vehicle: vehicle)
            }.result()
        }.bind { [self] it in
            self.viewModel.vehicles.accept(viewModel.vehicles.value + [it])
        }.disposed(by: disposeBag)
        
        viewModel.newVehicleClicked.flatMap{ it in
            NewVehicleScreenViewController().apply { [self] it in
                self.present(it, animated: true)
//                guard let vehicle = self.viewModel.vehicle.value else {return}
//                it.viewModel.loadVehicleInfo(vehicle: vehicle)
            }.result()
        }.bind { [self] it in
            self.viewModel.vehicles.accept(viewModel.vehicles.value + [it])
        }.disposed(by: disposeBag)
        
//        viewModel.vehicleClicked.flatMap{ vehicle in
//            NewVehicleScreenViewController().apply { [self] it in
//                self.present(it, animated: true)
//                it.viewModel.loadVehicleInfo(vehicle: vehicle)
//            }.result()
//        }.bind{ [self] it in
//                var vehicleItems =  self.viewModel.vehicles.value
//                for i in 0...vehicleItems.count-1{
//                    if(vehicleItems[i].id == it.id){
//                        vehicleItems[i] = it
//                        self.viewModel.vehicles.accept(vehicleItems)
//                        break
//                    }
//                }
//        }.disposed(by: disposeBag)
        
        let datasource = RxCollectionViewSectionedAnimatedDataSource<SectionOf<ItemOrNew<VehicleDetails>>>(
            animationConfiguration: AnimationConfiguration()) { [self] dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovableItemWithLabel.Identifier, for: indexPath) as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let vehicle) :
                    cell.image.loadImage(src: vehicle.images.first)
                    cell.label.text = vehicle.name
                    cell.image.layer.cornerRadius = 20
                    cell.image.clipsToBounds = true
                    cell.minusIcon.isHidden = false
                    cell.minusIcon.rx.tapGesture().when(.recognized)
                        .map { it in
                            vehicle.id
                        }.bind(to:viewModel.removeVehicleClicked)
                        .disposed(by: cell.disposeBag)
                    
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in
                            vehicle
                        }
                        .bind(to: viewModel.vehicleClicked)
                        .disposed(by: cell.disposeBag)
                    break
                    
                case .New :
                    cell.image.image = UIImage(named: "ic_circle_outline_plus")
                    cell.label.text = "New"
                    cell.image.layer.cornerRadius = 20
                    cell.image.clipsToBounds = false
                    cell.minusIcon.isHidden = true
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in  }
                        .bind(to: viewModel.newVehicleClicked)
                        .disposed(by: cell.disposeBag)
                    break
                }
                
                return cell
            }
        
        viewModel.vehicles.map {
            $0.isEmpty ?
            [] :
            $0.map { item in
                ItemOrNew.Item(item)
            } + [ItemOrNew.New]
            
        }.map{
            [SectionOf(items: $0)]
        }
        .bind(to: binding.vehiclesCollectionView.rx.items(dataSource: datasource))
        .disposed(by: disposeBag)
        
        viewModel.vehicles.map { !$0.isEmpty }
            .bind(to: binding.newVehicleView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindPets(){
        
        let datasource = RxCollectionViewSectionedAnimatedDataSource<SectionOf<ItemOrNew<PetDetails>>>(
            animationConfiguration: AnimationConfiguration()) { [self] dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovableItemWithLabel.Identifier, for: indexPath) as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let pet) :
                    cell.image.loadImage(src: pet.images.first, type: .Pet)
                    cell.label.text = pet.name
                    cell.image.layer.cornerRadius = 20
                    cell.image.clipsToBounds = true
                    cell.minusIcon.isHidden = false
                    cell.minusIcon.rx.tapGesture().when(.recognized)
                        .map { it in
                            pet.id
                        }.bind(to:viewModel.removePetButtonClicked)
                        .disposed(by: cell.disposeBag)
                    break
                    
                case .New :
                    cell.image.image = UIImage(named: "ic_circle_outline_plus")
                    cell.label.text = .SetupProfile.newPet
                    cell.image.layer.cornerRadius = 0
                    cell.image.clipsToBounds = false
                    cell.minusIcon.isHidden = true
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in }
                        .bind(to: viewModel.newPetButtonClciked)
                        .disposed(by: cell.disposeBag)
                    break
                }
                
                
                return cell
            }
        
        viewModel.pets.map {
            ($0.map { item in
                ItemOrNew.Item(item)
            } + [ItemOrNew.New])
        }.map{
            [SectionOf(items: $0)]
        }
        .bind(to: binding.petsCollectionView.rx.items(dataSource: datasource))
        .disposed(by: disposeBag)
    }
    
    func bindAvailableDays(){
        
        binding.breedPreferenceField.allowsEditingTextAttributes = false
        
        let workingHoursDataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOf<DayAvilability>>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .none,reloadAnimation: .none, deleteAnimation: .none)
        ) { [self] dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkingHourCell.Identifier, for: indexPath) as! WorkingHourCell
            cell.label.text = item.day
            cell.fromValue.text = item.from.asTimeString()
            cell.toValue.text = item.to.asTimeString()
            cell.fromPicker.pickerView.date = item.from
            cell.toPicker.pickerView.date = item.to
            cell.fromPicker.pickerView.rx.date
                .skip(1)
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .bind(onNext: { [unowned self] in
                    viewModel.updateFrom(dateOfWeek: item.day, date: $0)
                }).disposed(by: cell.disposeBag)
            
            cell.toPicker.pickerView.rx.date
                .skip(1)
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .bind(onNext: { [unowned self] in
                    viewModel.updateTo(dateOfWeek: item.day, date: $0)
                }).disposed(by: cell.disposeBag)
            
            return cell
        }
        
        viewModel.workingHours.map {
            [SectionOf(items: $0)]
        }
        .bind(to: binding.workingHoursCollection.rx.items(dataSource: workingHoursDataSource))
        .disposed(by: disposeBag)
        
        viewModel.availableDays
            .bind(to: binding.availableDaysCollection.rx.items(cellIdentifier: AvailableDayCell.Identifier)){  [self] (row, item, cell)  in
                
                let cell = cell as! AvailableDayCell
                
                cell.label.text = item.item[0..<2]
                cell.label.layer.borderColor = UIColor.onBackground.cgColor.copy(alpha:  item.isSelected ? 0.8: 0.1)
                cell.rx.tapGesture().when(.recognized)
                    .map { it in item }
                    .bind(to: viewModel.dayClicked)
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
        viewModel.petBehaviours.bind(to: binding.petBehaviourCollectionView.rx.items(cellIdentifier: PetBehaviourCell.Identifier )){ [self] (row, item, cell)  in
            
            let cell = cell as! PetBehaviourCell
            cell.label.text = item.item
            cell.checkBox.isChecked = item.isSelected
            
            cell.rx.tapGesture().when(.recognized)
                .map { it in item }
                .bind(to: viewModel.petBehaviourClicked)
                .disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        viewModel.petBehaviours.take(1).bind { [unowned self] items in
            binding.petBehaviourCollectionView.layoutIfNeeded()
            binding.petBehaviourCollectionView.snp.updateConstraints { make in
                make.height.equalTo(max(binding.petBehaviourCollectionView.contentSize.height * 2, 32))
            }
        }.disposed(by: disposeBag)
        
        viewModel.availableDays.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.workingHoursCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.workingHoursCollection.contentSize.height, 32))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
    }
    
}
