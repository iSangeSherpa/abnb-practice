//
//  BaseUICollectionViewCell.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 21/09/2022.
//

import Foundation
import UIKit
import RxSwift


extension UICollectionViewCell{
    static var Identifier : String {
        get {
            return String(describing: Self.self )
        }
        
        set {
            
        }
    }
}

class BaseUICollectionViewCell : UICollectionViewCell{
    
    public var disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    open func setupViews(){
        
    }
    
    open func setupConstraints(){
        
        
    }
}
