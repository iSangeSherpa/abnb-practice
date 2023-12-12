//
//  ViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 21/09/2022.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa
import UIKit
import MaterialComponents

extension ViewController{
    func bind(field:UITextField, relay : BehaviorRelay<String?>){
        
        relay.distinctUntilChanged().bind(to: field.rx.text).disposed(by: disposeBag)
        field.rx.text.orEmpty.bind(to: relay).disposed(by: disposeBag)
    }
    
    func bind(field:UITextField, relay : BehaviorRelay<String>){
        
        relay.distinctUntilChanged().bind(to: field.rx.text).disposed(by: disposeBag)
        field.rx.text.orEmpty.bind(to: relay).disposed(by: disposeBag)
    }
    
    func bind(field:MDCOutlinedTextArea, relay : BehaviorRelay<String>){
        relay.distinctUntilChanged().bind{
            [self] text in
            field.textView.text = text
        }.disposed(by: disposeBag)
        
        field.textView.rx.text.orEmpty.bind(to: relay).disposed(by: disposeBag)
    }
}
