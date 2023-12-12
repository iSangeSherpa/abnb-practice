//
//  UIView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/09/2022.
//

import UIKit
import SnapKit
import MaterialComponents.MaterialRipple


extension UIView{
    
    var isVisible:Bool{
        get{
            return !isHidden
        }
        set{
            isHidden = !newValue
        }
    }
    
    public func addSubViews(_ views: UIView...){
        views.forEach { it in
            addSubview(it)
        }
    }
    
    @discardableResult
    func enableRipple(rippleColor:UIColor = .onBackground.withAlphaComponent(0.1), style:MDCRippleStyle = .bounded, factor:Float = 1.0) -> MDCRippleTouchController{
        let rippleController  = MDCRippleTouchController()
        rippleController.rippleView.rippleColor = rippleColor
        rippleController.rippleView.rippleStyle = style
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        rippleController.rippleView.maximumRadius =  CGFloat(Float(min(size.height, size.width)) * factor)
        rippleController.addRipple(to: self)
        objc_setAssociatedObject(self, "[\(arc4random())]", rippleController, .OBJC_ASSOCIATION_RETAIN)
        
        return rippleController
    }
    
}

extension UIView {
    
    @discardableResult
    public func withSize(_ size: CGFloat) -> Self {
        
        return withSize(CGSize(width: size, height: size))
    }
    
    @discardableResult
    public func withSize(_ size: CGSize) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    
    @discardableResult
    public func withHeight(_ height: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func withWidth(_ width: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func withBorder(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
}

extension CGSize {
    static public func equalEdge(_ edge: CGFloat) -> CGSize {
        return .init(width: edge, height: edge)
    }
}

extension UIEdgeInsets {
    static public func allSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }
    
    static public func horizontal(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: side, bottom: 0, right: side)
    }
    
    static public func vertical(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: 0, bottom: side, right: 0)
    }
    
    init(vertical: CGFloat,horizontal: CGFloat){
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

}

extension UIImageView {
    convenience public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}

extension UIStackView {
    
    @discardableResult
    public func withMargins(_ margins: UIEdgeInsets) -> UIStackView {
        layoutMargins = margins
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    public func padLeft(_ left: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.left = left
        return self
    }
    
    @discardableResult
    public func padTop(_ top: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = top
        return self
    }
    
    @discardableResult
    public func padBottom(_ bottom: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.bottom = bottom
        return self
    }
    
    @discardableResult
    public func padRight(_ right: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.right = right
        return self
    }
}

extension UIImage {
    func scaledDown(into size:CGSize, centered:Bool = false) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleW, scaleH) = (1 as CGFloat, 1 as CGFloat)
        if targetWidth > size.width {
            scaleW = size.width/targetWidth
        }
        if targetHeight > size.height {
            scaleH = size.height/targetHeight
        }
        let scale = min(scaleW,scaleH)
        targetWidth *= scale; targetHeight *= scale
        let sz = CGSize(width:targetWidth, height:targetHeight)
        if !centered {
            return UIGraphicsImageRenderer(size:sz).image { _ in
                self.draw(in:CGRect(origin:.zero, size:sz))
            }
        }
        let x = (size.width - targetWidth)/2
        let y = (size.height - targetHeight)/2
        let origin = CGPoint(x:x,y:y)
        return UIGraphicsImageRenderer(size:size).image { _ in
            self.draw(in:CGRect(origin:origin, size:sz))
        }
    }
}


protocol Badgeable {
    func addBadge(badgeCount:Int)
}

extension UIView: Badgeable {
    func addBadge(badgeCount:Int) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let diameter: CGFloat = 28
        var badge : UIButton = self.viewWithTag(1) as? UIButton ?? UIButton()
       
        
        if(badgeCount == 0){
            badge.removeFromSuperview()
            return
        }
        
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 20)
        badge.layer.cornerRadius = diameter / 2
        badge.setTitleColor(.white, for: .normal)
        badge.backgroundColor = .systemRed
        badge.setTitle("\(badgeCount)", for: .normal)
        badge.tag = 1
        addSubview(badge)

        NSLayoutConstraint.activate([
            badge.heightAnchor.constraint(equalToConstant: diameter),
            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: diameter),
            badge.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            badge.bottomAnchor.constraint(equalTo: topAnchor, constant: 16),
        ])
    }
}

