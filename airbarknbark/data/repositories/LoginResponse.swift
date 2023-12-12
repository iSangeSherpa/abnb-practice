//
//  UserLoginResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 21/11/2022.
//

import Foundation

struct LoginResponse : Codable{
    let data: LoginSession
}

struct LoginSession : Codable{
    let id : String
    let refreshToken: String
    let ip: String
    let userId: String
    let createdAt : String
    let expiresAfter : Int
    let accessToken : AccessToken
}

struct AccessToken : Codable{
    let token: String
    let createdAt : String?
    let expiresAfter : Int
}
