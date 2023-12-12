//
//  TermsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 06/03/2023.
//

import Foundation
import WebKit
import RxSwift

class AcceptTermsViewController : ViewController<AcceptTermsView,AcceptTermsViewModel>, WKNavigationDelegate{
    
    override func setupView() {
        let myURL = URL(string: .Register.termsLink)
        let myRequest = URLRequest(url: myURL!)
        binding.webView.load(myRequest)
        binding.webView.navigationDelegate = self
        
        binding.backButton.rx.tapGesture().when(.recognized).bind{ _ in
            self.dismiss(animated: true)
            self.viewModel.onTermsActionPerformed.accept(false)
        }.disposed(by: disposeBag)
        
        binding.cancelButton.rx.tapGesture().when(.recognized).bind{ _ in
            self.dismiss(animated: true)
            self.viewModel.onTermsActionPerformed.accept(false)
        }.disposed(by: disposeBag)
        
        binding.okButton.rx.tapGesture().when(.recognized).bind{ _ in
            self.dismiss(animated: true)
            self.viewModel.onTermsActionPerformed.accept(true)
        }.disposed(by: disposeBag)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          self.viewModel.loading.accept(true)
    }
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewModel.loading.accept(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.viewModel.loading.accept(false)
    }
    
    
    func result() -> Observable<Bool>{
        return viewModel.onTermsActionPerformed.asObservable()
    }
}
