//
//  View.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import UIKit


class BaseUIView : UIView{

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
    
    open func setupViews(){
        
    }
    
    open func setupConstraints(){
        
        
    }
    
}
