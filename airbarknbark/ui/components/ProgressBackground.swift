//
//  ProgressBackground.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 19/10/2022.
//

import Foundation
import UIKit

class ProgressBackground :  UIView {
    
    public var totalDegrees: Double = 270 {
        didSet {
            setNeedsLayout()
        }
    }
    public var arcFillColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let arcLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() -> Void {
        layer.addSublayer(arcLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arcLayer.fillColor = arcFillColor.cgColor
        
        // stroke is drawn on centerline, so
        //  inset the drawing area by one-half the line width
        let drawRect = bounds
        
        // outer radius is one-half the width of the view
        let outerRadius = drawRect.width * 0.5
        
        // adjust insets as desired
        let middleCircleRect = drawRect.insetBy(dx: drawRect.width * 0.15, dy: drawRect.width * 0.15)
        let innerCircleRect = CGRect.zero
        
        var pth: UIBezierPath!
        
        pth = UIBezierPath(ovalIn: middleCircleRect)
        pth.append(UIBezierPath(ovalIn: innerCircleRect))
        
        
        // we want the arc to be centered at 3 o'clock
        let startDegrees = -90.0
        let endDegrees = startDegrees + totalDegrees
        
        // convert to radians
        let startAngle = startDegrees * .pi / 180
        let endAngle = endDegrees * .pi / 180
        
        pth = UIBezierPath()
        
        // add a clockwise arc with outer radius
        pth.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        // add a counter-clockwise arc with radius from the inner circle rect
        pth.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: innerCircleRect.width * 0.5, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        // close the arc path
        pth.close()
        
        arcLayer.path = pth.cgPath
    }
    
}
