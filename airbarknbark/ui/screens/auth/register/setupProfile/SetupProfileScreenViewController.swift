//
//  SetupProfileScreenViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/09/2022.
//

import Foundation
import UIKit
import MaterialComponents.MaterialDialogs
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
import RxGesture
import BSImagePicker
import SDWebImage


class SetupProfileScreenViewController : ViewController<SetupProfileScreenView,SetupProfileViewModel>{
    
    override func setupView() {
        
        viewModel.userProfileImage.bind(to: binding.userProfileImage.rx.image).disposed(by: disposeBag)
        
        viewModel.userProfileImage.subscribe(onNext: { [weak self] in
            
            guard let preview = self?.binding.plusIcon else { return }
            preview.isHidden =  $0 !== nil
            
        }).disposed(by: disposeBag)
        
        Observable.merge(
            binding.maleCheckBox.checkBox.rx.checkChanges.filter{ $0 }.map{ it in Gender.MALE },
            binding.femaleCheckBox.checkBox.rx.checkChanges.filter{ $0 }.map{ it in Gender.FEMALE },
            binding.genderOtherCheckBox.checkBox.rx.checkChanges.filter{ $0 }.map{ it in Gender.OTHER }
        ).bind(to: viewModel.gender)
            .disposed(by: disposeBag)
        
    
        viewModel.gender
            .bind(onNext: { [weak self] it in
                self?.binding.maleCheckBox.checkBox.isChecked = it == Gender.MALE
                self?.binding.femaleCheckBox.checkBox.isChecked = it == Gender.FEMALE
                self?.binding.genderOtherCheckBox.checkBox.isChecked = it == Gender.OTHER
            })
            .disposed(by: disposeBag)
        
        
        viewModel.newPetButtonClciked.flatMap { it in
            
            return  NewPetScreenViewController().apply { [self] it in
                self.present(it, animated: true)
            }.result()
            
        }
        .bind { [self] it in
            self.viewModel.pets.accept(viewModel.pets.value + [it])
        }.disposed(by: disposeBag)
        
        
        binding.backButton.rx.tap
            .bind{
                guard let navigationStack = self.navigationController?.viewControllers, navigationStack.count > 1 else {
                    self.view.window?.rootViewController =  UINavigationController( rootViewController: LoginScreenViewController())
                    return
                }
                self.viewModel.dismissBy.accept(Void())
            }
            .disposed(by: disposeBag)
        
        binding.continueButton.rx.tapGesture()
            .when(.recognized)
            .flatMap { [self] it in
                showJoiningTypeDialog()
            }.bind { [self] userType in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.viewModel.updateUserDetails(userType:userType)
                }
            }.disposed(by: disposeBag)
        
        binding.uploadPhotoView.rx.tapGesture()
            .when(.recognized)
            .flatMap { [self] it in
                pickImages(max:1)
            }.map{
                $0.first
            }
            .filter { $0 != nil }
            .bind(to: viewModel.userProfileImage).disposed(by: disposeBag)
        
        viewModel.updateDetailsAction.bind{
            [self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.pushViewController(RegisterVerificationScreenViewController().apply({ it in
                    it.viewModel.forIncompleteProfile = self.viewModel.forIncompleteProfile
                }), animated: true)
            }
        }.disposed(by: disposeBag)
        
       
        bind(field: binding.fullNameInputField, relay: viewModel.fullName)
        viewModel.fetchedShortBio.bind{
            self.binding.bioInputField.textView.text = $0
            self.binding.bioInputField.textView.becomeFirstResponder()
            self.binding.bioInputField.textView.resignFirstResponder()
        }.disposed(by: disposeBag)
        binding.bioInputField.textView.rx.text.orEmpty.bind(to: viewModel.shortBio).disposed(by: disposeBag)
        
        
                
        viewModel.userProfileImageURL.bind{
            self.binding.plusIcon.isHidden = ($0 != nil)
            self.binding.userProfileImage.loadImage(src: $0 , type: .User)
        }.disposed(by: disposeBag)
        
        if(viewModel.forIncompleteProfile){
            viewModel.loadData()
        }
        
        bindPets()
    }
    
    
    func bindPets(){
        
        let datasource = RxCollectionViewSectionedAnimatedDataSource<SectionOf<ItemOrNew<PetDetails>>>(
            animationConfiguration: AnimationConfiguration()) { [self] dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovableItemWithLabel.Identifier, for: indexPath) as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let pet) :
                    cell.image.loadImage(src:  pet.images.first, type: .Pet)
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
    
    func showJoiningTypeDialog() -> Maybe<ActiveProfile>{
        return [.create{ [self] maybe in
            let viewController = DialogViewController<JoiningAsDialogView,ViewModel>().setupBy { dialog in
                dialog.binding.crossButton.addOnClickListner {
                    maybe(.completed)
                }
                dialog.binding.cancelButton.addOnClickListner {
                    maybe(.completed)
                }
                dialog.binding.optionMinder.addOnClickListner {
                    maybe(.success(.MINDER))
                }
                dialog.binding.optionFinder.addOnClickListner {
                    maybe(.success(.FINDER))
                }
                dialog.binding.optionBoth.addOnClickListner {
                    maybe(.success(.BOTH))
                }
            }
            present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }][0]
    }
    
}
