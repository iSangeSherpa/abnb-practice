//
//  UserAnnotation.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/12/2022.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var name : String
    var distance : String
    var imageURL : String
    var ownLocation : Bool
    var activeProfile : ActiveProfile
    var isProfileVerified : Bool
    var hasMinderProfile : Bool
    
    init(id: String = UUID().uuidString , coordinate: CLLocationCoordinate2D, name: String, distance:String, imageURL : String,ownLocation : Bool = false,activeProfile : ActiveProfile,isProfileVerified:Bool,hasMinderProfile:Bool) {
        self.id = id
        self.coordinate = coordinate
        self.name = name
        self.distance = distance
        self.imageURL = imageURL
        self.ownLocation = ownLocation
        self.activeProfile = activeProfile
        self.isProfileVerified = isProfileVerified
        self.hasMinderProfile = hasMinderProfile
    }
}
