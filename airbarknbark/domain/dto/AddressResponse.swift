//
//  AddressResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/11/2022.
//

import Foundation

struct AddressDetails : Codable{
    let userId : String
    let name: String
    let longitude : Float
    let latitude : Float
    
    func randomizeAccuracy() -> AddressDetails{
        let newLat = latitude + Float.random(in: Config.LOCATION_RANDOMIZER_RANGE)
        let newLng = longitude + Float.random(in: Config.LOCATION_RANDOMIZER_RANGE)
        return AddressDetails(userId: userId, name: name, longitude: newLng, latitude: newLat)
    }
}
