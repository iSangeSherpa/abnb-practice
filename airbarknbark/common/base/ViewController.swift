//
//  BaseController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/09/2022.
//

import Foundation
import UIKit
import RxSwift
import SVProgressHUD

open class ViewController<V : UIView, VM:ViewModel> : UIViewController, UIGestureRecognizerDelegate{
    
    public var isBackGestureEnabled = true
    public let viewModel = VM()
    public let disposeBag = DisposeBag()
    
    open var binding: V {
        if let myView = view as? V {
            return myView
        }
        
        let newView = V()
        view = newView
        return newView
    }
    
    open override func loadView() {
        view = V()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        bindCommonRxEvents()
        
        setupView()
    }
    
    open func setupView() {
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return isBackGestureEnabled
    }
    
    
    func bindCommonRxEvents(){
        viewModel.dismissBy
            .observe(on: MainScheduler.instance)
            .bind(onNext:{[unowned self] _ in self.handlePop()})
            .disposed(by: disposeBag)
        
        viewModel.loading
            .observe(on: MainScheduler.instance)
            .bind(onNext:{[unowned self] isLoading in self.handleLoadingUI(isLoading:isLoading)}).disposed(by: disposeBag)
        
        viewModel.alerts.observe(on: MainScheduler.instance)
            .bind(onNext:{[unowned self] alert in self.handleAlert(alert:alert)})
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind(onNext: {[unowned self] error in self.handleError(error : error)})
            .disposed(by: disposeBag)
        
        viewModel.navActions.subscribe(onNext: { [weak self] it in
            self?.handleNavAction(action: it)
        }).disposed(by: disposeBag)
    }
    
    func handleAlert(alert:Alert){
        switch(alert){
        case .error(let message, let action):
            self.alert(alertText: .error, alertMessage: message, handler: {it in action?() }, tint: .error)
            break;
        case .success(let message, let action):
            self.alert(alertText: .alert, alertMessage: message, handler: {it in action?() }, tint: .primary)
            break;
        }
    }
    
    
    func handlePop(){
        self.navigationController?.popViewController(animated: true)
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
        
        #if DEBUG
        print(error)
        #endif
        
        if let error = error as? Failure{
            if case .UnAuthenticatedError = error {
                handleAlert(alert: .error( error.message(), action: { [weak self] in
                    (self?.view.window?.windowScene?.delegate as? SceneDelegate)?.performSignOutCleanUp()
                }))
                return
            }
        }
        handleAlert(alert: .error(error.message()))
    }
    
    func handleNavAction(action:NavAction){
        switch(action){
            
        case .push(_:_, _:let clearBackStack):
            let viewController = action.createViewController()!
            self.navigationController?.pushViewController(viewController, animated: true)
            if(clearBackStack){
                self.navigationController?.viewControllers = [viewController]
            }
            break;
        case .present:
            self.navigationController?.present(action.createViewController()!, animated: true)
            break;
        case .pop:
           handlePop()
            break
        }
    }
}

