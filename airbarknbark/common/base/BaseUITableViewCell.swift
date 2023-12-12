//
//  BaseUITableViewCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 29/12/2022.
//

import Foundation
import UIKit
import RxSwift


extension UITableViewCell{
    static var Identifier : String {
        get {
            return String(describing: Self.self )
        }
        set {
            
        }
    }
}

class BaseUITableViewCell : UITableViewCell{
    
    public var disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
            
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
