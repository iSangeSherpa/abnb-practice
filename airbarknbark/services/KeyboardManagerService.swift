//
//  KeyboardManagerAppDelegate.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/12/2022.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift


class KeyboardManagerService:AppService {
    
    func appDidStarted(application: UIApplication) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsViewController.self]
        IQKeyboardManager.shared.disabledToolbarClasses = [ChatDetailsViewController.self]
    }
}
