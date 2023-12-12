//
//  UIView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import UIKit


func VSpacer(_ height:Int) -> UIView {
    return UIView().withHeight(height.cgFloat);
}

func VDivider(_ height:Int = 1) -> UIView {
    return VSpacer(height).apply{ it in
        it.backgroundColor = .onBackground.withAlphaComponent(0.1)
    }
}

func HDivider(_ width:Int = 1, verticalMargin:Int = 2, alpha:CGFloat = 0.1) -> UIView {
    
    let innerView = UIView().apply { it in
        it.backgroundColor = .onBackground.withAlphaComponent(alpha)
    }
    
    return HSpacer(width).apply{ it in
        it.addSubview(innerView)
        innerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(verticalMargin)
        }
    }
}


func HSpacer(_ width:Int) -> UIView {
    return UIView().withWidth(width.cgFloat);
}

func DotView(_ size:Int, color:UIColor = .primary) -> UIView {
    UIView().withWidth(size.cgFloat).apply{ it in
        
        let dotView = UIView()
        it.addSubview(dotView)
        
        dotView.snp.makeConstraints { make in
            make.height.equalTo(dotView.snp.width)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }

        dotView.layer.cornerRadius = (size / 2).cgFloat
        dotView.backgroundColor  = .primary
    }
}

extension UIView {
    
    func wrap( container:UIView, _ block: (_ parent:UIView, _ child:UIView)->Void) -> UIView{
        
        container.addSubview(self)
        block(container,self)
        
        return container
    }
    
    func wrapInUIView(_ block: (_ container:UIView, _ child:UIView)->Void) -> UIView{
        
        return UIView().apply{ container in
            container.addSubview(self)
            block(container,self)
        }
    }
}
