//
//  UILabel.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/09/2022.
//

import Foundation
import UIKit

func TitleH1(label:String) -> BetterUILabel {
    return BetterUILabel().apply() {
        $0.text = label
        $0.textColor = .onBackground
        $0.font = .poppinsSemibold(fontSize: 26)
        $0.sizeToFit()
    }
}

func TitleH1Bold(label:String) -> BetterUILabel {
    return TitleH1(label: label).apply() {
        $0.font = .poppinsBold(fontSize: 26)
    }
}

func TitleH2(label:String) -> BetterUILabel {
    return TitleH1(label: label).apply() {
        $0.font = .poppinsBold(fontSize: 23)
    }
}

func TitleH3(label:String) -> BetterUILabel {
    return TitleH1(label: label).apply() {
        $0.font = .poppinsSemibold(fontSize: 16)
    }
}

func TextBody(
    label:String,
    color:UIColor = .onBackground,
    font:UIFont = .body,
    alpha: Float = 1,
    noOfLines : Int = 1,
    alignment: NSTextAlignment = .center
) -> BetterUILabel {
    
    return BetterUILabel().apply() {
        $0.text = label
        $0.numberOfLines = noOfLines
        $0.textAlignment = alignment
        $0.textColor = color
        $0.font = font
        $0.sizeToFit()
    }
}


func Caption(
    label:String,
    color:UIColor = .onBackground,
    font:UIFont = .caption,
    alpha: Float = 1,
    textAlignment:NSTextAlignment = .center
) -> BetterUILabel {
    
   return BetterUILabel().apply() {
        $0.text = label
        $0.numberOfLines = 0
        $0.textAlignment = textAlignment
        $0.textColor = color
        $0.font = font
        $0.alpha = CGFloat(alpha)
        $0.sizeToFit()
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .horizontal)

    }
}

