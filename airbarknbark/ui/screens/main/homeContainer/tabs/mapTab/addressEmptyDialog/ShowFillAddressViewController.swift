//
//  ShowFillAddressViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/08/2023.
//

import Foundation

class ShowFillAddressViewController : BottomSheetViewController<ShowFillAddressView,ShowFillAddressViewModel>{
    
    override var popupHeight: CGFloat {
        return 250.cgFloat
    }
    
    
    override func setupView() {
        binding.crossButton.rx.tapGesture().when(.recognized).bind{ _ in
            self.dismiss(animated: true)
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
    }
}
