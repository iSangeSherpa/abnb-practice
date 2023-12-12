//
//  DialogUIController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 16/09/2022.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialDialogs


open class DialogViewController <V : UIView,VM:ViewModel> : ViewController<V,VM>{
    
    public let dialogTransitionController = MDCDialogTransitionController()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = dialogTransitionController
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private var _setupBy : ((DialogViewController<V,VM>)->Void)? = nil
    
    func setupBy(action: @escaping ((DialogViewController<V,VM>)->Void)) -> DialogViewController<V,VM> {
        _setupBy = action;
        
        return self
    }

    
    open override func setupView() {
        _setupBy?(self)
    }
    
    
    public override var preferredContentSize: CGSize {
        get {
            return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
}
