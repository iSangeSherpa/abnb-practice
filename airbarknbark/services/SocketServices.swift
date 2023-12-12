//
//  SocketService.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 08/12/2022.
//

import Foundation
import UIKit

class SocketServices: AppService {
    func appDidStarted(application: UIApplication) {
        SocketService.shared.connect()
    }
}
