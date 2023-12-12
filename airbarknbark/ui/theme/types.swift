//
//  types.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 06/09/2022.
//

import Foundation
import UIKit

extension UIFont {
    
    static func poppinsLight (fontSize : CGFloat) -> UIFont{
       return UIFont(name: "Poppins-Light", size: fontSize)!
    }
    
    static func poppinsRegular (fontSize : CGFloat) -> UIFont{
        return UIFont(name: "Poppins-Regular", size: fontSize)!
    }
    
    static func poppinsMedium (fontSize : CGFloat) -> UIFont{
       return UIFont(name: "Poppins-Medium", size: fontSize)!
    }
    
    
    static func poppinsSemibold (fontSize : CGFloat) -> UIFont{
       return UIFont(name: "Poppins-SemiBold", size: fontSize)!
    }
    
    static func poppinsBold (fontSize : CGFloat) -> UIFont{
       return UIFont(name: "Poppins-Bold", size: fontSize)!
    }
    
    static let body = poppinsRegular(fontSize: 14)
    static let bodyMedium = poppinsMedium(fontSize: 14)

    static let caption = poppinsRegular(fontSize: 12)
    static let captionMedium = poppinsRegular(fontSize: 12)
    static let captionSemiBold = poppinsSemibold(fontSize: 12)
    static let captionLight = poppinsLight(fontSize: 12)
    
    static let captionTinyMedium = poppinsMedium(fontSize: 10)

    
}
