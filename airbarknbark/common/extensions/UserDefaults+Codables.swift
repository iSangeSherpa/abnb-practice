//
//  UserDefaults+Codables.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/12/2022.
//

import Foundation

extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        let encoded = try? Config.jsonEncoder.encode(data)
        set(encoded, forKey: defaultName)
    }
    
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? Config.jsonDecoder.decode(T.self, from: userDefaultData)
    }
}
