//
//  EnableLocationViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/09/2023.
//

import Foundation
import UIKit

class EnableLocationViewController : BottomSheetViewController<EnableLocationView,EnableLocationViewModel>{
    
    override var popupHeight: CGFloat {
        return 225.cgFloat
    }
    
    
    override func setupView() {
        binding.buttonDone.rx.tapGesture().when(.recognized).bind{ [weak self] _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        binding.crossButton.rx.tapGesture().when(.recognized).bind{[weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
