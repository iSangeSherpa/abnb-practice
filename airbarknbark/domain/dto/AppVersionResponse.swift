//
//  AppVersionResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 30/05/2023.
//

import Foundation

struct AppVersion: Codable {
    var ios: String?
    var url: String?
    var forceUpdate:Bool?
    var appStoreLink:String?
    var message:String?
}
