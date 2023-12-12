//
//  BetterUILabel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/09/2022.
//

import Foundation
import UIKit

class BetterUILabel : UILabel {

    var eddgeInset = UIEdgeInsets.zero
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by:eddgeInset ))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += eddgeInset.top + eddgeInset.bottom
            contentSize.width += eddgeInset.left + eddgeInset.right
            return contentSize
        }
    }
}
