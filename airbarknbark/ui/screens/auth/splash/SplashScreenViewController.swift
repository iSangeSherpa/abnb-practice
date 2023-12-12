//
//  ViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 06/09/2022.
//

import UIKit
import SnapKit

class SplashScreenViewController: ViewController<SplashScreenView,SplashScreenViewModel> {
    
    override func setupView() {
        viewModel.requireForceUpdate.bind{
            UpdateAppDialogView.showPopupDialog(vc: self, appUrl: $0.appStoreLink ?? "", title: "Update app", body: $0.message ?? "")
                .subscribe(onSuccess: {
                   
                },onCompleted: {
                  
                }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        viewModel.checkAppVersionAndSesion()
    }
   
    override func handleLoadingUI(isLoading: Bool) {
        if(isLoading){
            binding.progressView.startAnimating()
        }else{
            binding.progressView.stopAnimating()
        }
    }
    
    override func handleError(error: Error) {
        super.handleError(error: error)
//        alert(alertText: .error, alertMessage: error.message(),dismissMessage: .tryAgain){  [unowned self] it in
//            self.viewModel.fetchUserDetails()
//        }
    }
    
}

