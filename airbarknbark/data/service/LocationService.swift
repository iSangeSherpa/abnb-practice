//
//  LocationService.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 08/12/2022.
//

import Foundation
import SwiftLocation
import RealmSwift
import RxSwift
import CoreLocation

class LocationService {
    
    let userRepository = UserRepositoryImpl()
    static let shared = LocationService()
    let disposedBag = DisposeBag()
    let realm = try! Realm()
    
    func getLocation(callbackListener : ((Result<CLLocation, LocationManager.ErrorReason>) -> ())? = nil ){
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city,timeout: .absolute(10)) { [self] result in
            
            switch result {
            case .failure(let error):
                let status: CLAuthorizationStatus
                if #available(iOS 14, *) {
                    status = CLLocationManager().authorizationStatus
                } else {
                    status = CLLocationManager.authorizationStatus()
                }
                switch status {
                case .authorizedAlways:
                    print("authorization")
                case .authorizedWhenInUse:
                    print("authorizedwhen in use")
                case .denied:
                    showAlertDialog(title: "Error!", message: "Location permission denied.")
                case .notDetermined:
                    self.retry(afterSecond: 3)
                case .restricted:
                    self.showAlertDialog(title: "Error!", message: "Location permission denied.")
                default:
                    self.showAlertDialog(title: "Error!", message: "Location permission denied."){
                        self.retry(afterSecond: 3)
                    }
                }
                
                debugPrint("Received error: \(error)")
                
            case .success(let location):
                debugPrint("Location received: \(location)")
                
                try! self.realm.write{
                    let locationList = realm.objects(LocationDetails.self)
                    if(!locationList.isEmpty){
                        let locationDetails = locationList.first
                        locationDetails!.latitude = Float(location.coordinate.latitude)
                        locationDetails!.longitude = Float(location.coordinate.longitude)
                    }else{
                        realm.add(
                            LocationDetails(
                                latitude: Float(location.coordinate.latitude),
                                longitude: Float(location.coordinate.longitude)
                            )
                        )
                    }
                }
                updateLocationForTravellingMinder(location: location)
            }
            callbackListener?(result)
        }
        
    }
    
    func locationServicesEnabled(callback  : @escaping (Bool)->()){
        if CLLocationManager.locationServicesEnabled() {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                callback(false)
            case .authorizedAlways, .authorizedWhenInUse:
                callback(true)
            default:
                break
            }
        } else {
            callback(false)
        }
        
    }
    func retry(afterSecond : Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(afterSecond)) {
            self.getLocation()
        }
    }
    
    func updateLocationForTravellingMinder(location:CLLocation){
//        guard let isTravelling = (SessionManager.shared.user?.minderProfile?.traveling) else{
//            return
//        }
//        if(isTravelling)
//        {
        getPlaceName(location: location){
            self.userRepository.updateAddress(addressDetail: Address(lat: location.coordinate.latitude, lang: location.coordinate.longitude, name: $0 ))
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: {_ in
                    print("Location updated")
                }).disposed(by: self.disposedBag)
        }
        //        }
    }
    
    
    func getPlaceName(location:CLLocation?, placeCallbackHandler: ((String)->())?){
        guard let location = location else {
            placeCallbackHandler?("")
            return
        }
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            let locationName = placeMark?.name ?? ""
            placeCallbackHandler?(locationName)
        })
    }
}

extension LocationService {
    
    func showAlertDialog(title : String, message : String, retry: (()->())? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: retry == nil ? "OK" : "Retry", style: .cancel, handler: { (_) in
            retry?()
        }))
        var rootViewController = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            rootViewController?.present(alert, animated: true)
        }
    }
}


class LocationDetails : Object{
    @Persisted var latitude : Float
    @Persisted var longitude : Float
    
    convenience init(latitude: Float, longitude: Float) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    func getDistance(latitude: Float?, longitude : Float?, appendingText: String = "") -> (rangeText:String,distance:Double){
        if (latitude == nil || longitude == nil) {
            return ("N/A",0.0)
        }
        let point1 = CLLocation(
            latitude: CLLocationDegrees(self.latitude),
            longitude: CLLocationDegrees(self.longitude)
        )
        
        let point2 = CLLocation(
            latitude: CLLocationDegrees(latitude!),
            longitude: CLLocationDegrees(longitude!)
        )
        
        let km = point1.distance(from: point2)/1000
        
        var kmRange = 0
        
        switch km{
        case 0...1 :
            kmRange = 1
        case 1...2 :
            kmRange = 2
        case 2...5 :
            kmRange = 5
        case 5...10 :
            kmRange = 10
        case 10...20 :
            kmRange = 20
        case 20...50 :
            kmRange = 50
        case 50... :
            kmRange = 50
        default:
            kmRange = 0
        }
       
        return (String(format: "\((km<50.0) ? "<" : ">") %d KM \(appendingText)", kmRange),km)
        
    }
    
    func randomizeAccuracy() -> LocationDetails{
        let newLat = latitude + Float.random(in: Config.LOCATION_RANDOMIZER_RANGE)
        let newLng = longitude + Float.random(in: Config.LOCATION_RANDOMIZER_RANGE)
        return LocationDetails(latitude: newLat, longitude: newLng)
    }
}
