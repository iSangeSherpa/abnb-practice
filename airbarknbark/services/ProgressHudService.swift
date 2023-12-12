//
//  ProgressHudService.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/12/2022.
//

import Foundation
import SVProgressHUD

class ProgressHUDService: AppService {
    func appDidStarted(application: UIApplication) {
        SVProgressHUD.setDefaultMaskType(.black)
    }
}
