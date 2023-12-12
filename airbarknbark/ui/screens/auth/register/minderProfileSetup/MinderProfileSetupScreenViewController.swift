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
import RxSwift
import RxCocoa

class MinderProfileSetupScreenViewController : ViewController<MinderProfileSetupScreenView, MinderProfileSetupScreenViewModel>{
    
    override func setupView() {
        //MARK: - Hidden for now
        binding.availableDaysContainer.isHidden = true
        binding.workingHoursContainer.isHidden = true
        
        
        binding.backButton.rx.tap
            .bind(to: viewModel.dismissBy)
            .disposed(by: disposeBag)
        
        
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
                self.viewModel.noExperienceCheckbox.accept(it)
                return ""
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
        
        bind(field: binding.manualPetbehaviour, relay: viewModel.customPetBehaviour)
        
        viewModel.acceptTerms.bind(to: binding.termsCheckBox.rx.isChecked).disposed(by: disposeBag)
        
        binding.termsCheckBox.rx.tapGesture().when(.recognized).bind{ _ in
            if(self.binding.termsCheckBox.isChecked){
                self.viewModel.acceptTerms.accept(false)
                return
            }
            
            AcceptTermsViewController().apply { it in
                self.present(it, animated: true)
            }.result().bind{ checkedResult in
                self.viewModel.acceptTerms.accept(checkedResult)
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        
        binding.continueButton.rx.tap
            .bind { [unowned self] void in
                viewModel.updateMinderProfile()
            }.disposed(by: disposeBag)
        
        
        viewModel.onUpdateMinderProfile.bind{ [unowned self] void  in
            if(self.viewModel.fromProfile){
                self.viewModel.dismissBy.accept(Void())
                self.viewModel.continueButtonClicked.accept(Void())
                return
            }
            PopupDialogView.showPopupDialog(
                vc: self,
                title: .Dialog.sentForVerificationTitle,
                body: .Dialog.sentForVerificationBody,
                buttonText : .Dialog.gotoHome
            ).subscribe(onSuccess: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.navigationController?.pushViewController(HomeContainerScreenViewController(), animated: true)
                }
            },onCompleted: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.navigationController?.pushViewController(HomeContainerScreenViewController(), animated: true)
                }
            }).disposed(by: disposeBag)
        }.disposed(by: disposeBag)
        
        bindAvailableDays()
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
            .bind(to: binding.availableDaysCollection.rx.items(cellIdentifier: AvailableDayCell.Identifier)){(row, item, cell)  in
                
                let cell = cell as! AvailableDayCell
                cell.label.text = item.item[0..<2]
                cell.label.layer.borderColor = UIColor.onBackground.cgColor.copy(alpha:  item.isSelected ? 0.8: 0.1)
            }.disposed(by: disposeBag)
        
        binding.availableDaysCollection.rx.itemSelected
            .withLatestFrom(viewModel.availableDays){ path, days in
                days[path.row]
            }
            .bind(to: self.viewModel.dayClicked)
            .disposed(by: disposeBag)
        
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
        
        if(viewModel.forIncompleteProfile){
            viewModel.loadMinderProfileDetails()
            viewModel.getDocuments()
        }
    }
    
    
    func result() -> Observable<Void>{
        return viewModel.continueButtonClicked.asObservable()
    }
    
}

