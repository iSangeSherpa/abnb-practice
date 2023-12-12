//
//  BottomPopupViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import BottomPopup
import RxSwift
import SVProgressHUD

class BottomSheetViewController<V : UIView, VM:ViewModel> : BottomPopupViewController, BottomPopupDelegate{
    
    public let viewModel = VM()
    public let disposeBag = DisposeBag()
    
    let binding = V()
    
    override var popupShouldDismissInteractivelty: Bool{
        return false
    }
    
    override var popupShouldBeganDismiss: Bool{
        return false
    }
    
    override func viewDidLoad() {
        self.popupDelegate = self
    }
    
    func bottomPopupWillAppear() {
        view.addSubview(binding)
        view.backgroundColor = .background
        bindCommonRxEvents()
        
        setupView()
        setupConstraints()
       
    }
    
    func setupConstraints(){
        binding.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    open func setupView() {
        
    }

    
    
    func bindCommonRxEvents(){
        viewModel.dismissBy
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.handlePop)
            .disposed(by: disposeBag)
        
        viewModel.loading
            .observe(on: MainScheduler.instance)
            .bind(onNext:handleLoadingUI(isLoading:)).disposed(by: disposeBag)
        
        viewModel.alerts.observe(on: MainScheduler.instance)
            .bind(onNext: self.handleAlert(alert:))
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind(onNext: self.handleError)
            .disposed(by: disposeBag)
        
    }
    
    func handleAlert(alert:Alert){
        switch(alert){
        case .error(let message,_):
            self.alert(alertText: .error, alertMessage: message, tint: .error)
            break;
        case .success(let message,_):
            self.alert(alertText: .alert, alertMessage: message, tint: .primary)
            break;
        }
    }
    
    
    func handlePop(){
        self.dismiss(animated: true)
    }
    
    func handleLoadingUI(isLoading:Bool){
        if(isLoading){
            SVProgressHUD.show()
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func handleError(error:Error){
        viewModel.alert(error.message())
        if let error = error as? Failure{
            if case .UnAuthenticatedError = error {
                // logout here
            }
        }
    }
    
    
}

