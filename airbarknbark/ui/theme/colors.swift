//
//  color.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 06/09/2022.
//

import Foundation
import UIKit


extension UIColor{
    private static var BARK_GREEN = UIColor(hexString: "#FF426a5a")
    private static var BARK_GREEN_LIGHT = UIColor(hexString: "#FF6f9887")
    private static var BARK_GREEN_DARK = UIColor(hexString: "#FF173f31")
    
    private static var BARK_YELLOW = UIColor(hexString: "#FFC107")
    private static var BARK_YELLOW_LIGHT = UIColor(hexString: "#FFffe49d")
    private static var BARK_YELLOW_DARK = UIColor(hexString: "#FFa68341")
    
    private static var BARK_MAROON = UIColor(hexString: "#CB4040")
    
    static var primary =  BARK_GREEN
    static var primaryVariant =  UIColor(light: BARK_GREEN_DARK, dark: BARK_GREEN_LIGHT)
    static var secondary = BARK_YELLOW
    static var secondaryVariant = UIColor(light: BARK_YELLOW_DARK, dark: BARK_YELLOW_LIGHT)
    static var maroon = UIColor(light: BARK_MAROON, dark: BARK_MAROON)
    
    
    static var background = UIColor(light: UIColor(hexString: "#FCFCFC"), dark: UIColor( hexString:  "#121212"))
    static var surface =  UIColor(light: .white, dark: UIColor( hexString:  "#121212"))
    static var error =  UIColor(lightHex: "#B00020", darkHex:  "#CF6679")
    static var onPrimary  = UIColor.white
    static var onSecondary = UIColor.white
    static var onBackground = UIColor(light: UIColor(hexString: "#242525"), dark: .white)
    static var onSurface = UIColor(light: .black, dark: .white)
    static var onError = UIColor.white
    
    static func random() -> UIColor {
        return  UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)

    }
}


extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(light:UIColor, dark: UIColor){
        if #available(iOS 13.0, *) {
            
            self.init(dynamicProvider: { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? dark : light;
            } )
        
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    convenience init(lightHex:String, darkHex: String) {
        self.init(light: UIColor(hexString: lightHex), dark:  UIColor(hexString: darkHex))
    }
}






