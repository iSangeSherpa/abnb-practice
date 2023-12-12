//
//  ApplyFilterViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 29/12/2022.
//

import Foundation
import RxSwift

class ApplyFilterViewController : BottomSheetViewController<ApplyFilterView,ApplyFilterViewModel>{
    
    override var popupHeight: CGFloat {
        return 450.cgFloat
    }
    
    override func setupView(){
        
        Observable.merge(
            binding.genderMaleCheckbox.rx.checkChanges.filter{ $0 }.map{ it in Gender.MALE },
            binding.genderFemaleCheckbox.rx.checkChanges.filter{ $0 }.map{ it in Gender.FEMALE },
            binding.genderOthersCheckbox.rx.checkChanges.filter{ $0 }.map{ it in Gender.OTHER }
        ).bind(to: viewModel.gender)
            .disposed(by: disposeBag)
        
        Observable.merge(
            binding.withPetCheckbox.rx.checkChanges.filter{$0}.map{it in .WITH_PET},
            binding.withoutPetCheckbox.rx.checkChanges.filter{$0}.map{it in .WITHOUT_PET}
        ).bind(to:viewModel.findersPreference)
            .disposed(by:disposeBag)
        
        binding.distanceSlider.rx.value
            .bind{ _ in
                self.viewModel.onDistanceSliderChange.accept(Void())
            }.disposed(by: disposeBag)
        
        binding.crossButton.rx.tapGesture().when(.recognized).bind{ _ in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        binding.searchButton.rx.tapGesture().when(.recognized).bind { [self] _ in
            self.viewModel.applyFiltersAndSearch()
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.gender.bind(onNext: { [weak self] it in
                self?.binding.genderMaleCheckbox.isChecked = it == Gender.MALE
                self?.binding.genderFemaleCheckbox.isChecked = it == Gender.FEMALE
                self?.binding.genderOthersCheckbox.isChecked = it == Gender.OTHER
            }).disposed(by: disposeBag)
        
        viewModel.findersPreference.bind(onNext:{ [weak self] it in
            self?.binding.withPetCheckbox.isChecked = it == .WITH_PET
            self?.binding.withoutPetCheckbox.isChecked = it == .WITHOUT_PET
        }).disposed(by: disposeBag)
        
        
        viewModel.maxDistance.bind{ maxDistance in
            self.binding.distanceSlider.value = Float(maxDistance)
            self.binding.distanceLabel.text = "\(maxDistance) km"
        }.disposed(by: disposeBag)
        
        viewModel.onDistanceSliderChange.bind{ _ in
            let maxDistance = Int(self.binding.distanceSlider.value)
            self.viewModel.maxDistance.accept(maxDistance)
        }.disposed(by: disposeBag)
    
    }

    func result() -> Observable<FilterParams>{
        return viewModel.onSearchClicked.asObservable()
    }

}
