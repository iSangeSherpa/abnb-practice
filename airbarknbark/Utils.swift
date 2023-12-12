//
//  Utils.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 29/11/2022.
//

import Foundation
import UIKit
import MapKit



struct DateUtils{
    static func getElapsedTime(from: Date?, to: Date? = Date.now)->(hr : Int, min : Int)?{
        guard let dateFrom = from , let dateTo = to else {return nil}
        let diff = Int(dateFrom.timeIntervalSince1970 - dateTo.timeIntervalSince1970 )
        let hours = Int(diff / 3600)
        let minutes = Int((diff - hours * 3600) / 60)
        
        return (hr : hours, min : minutes)
        
    }
}

extension Date{
    func format(dateFormat:String = "yyyy-MM-dd")->String{
        return self.format(dateFormatter:  DateFormatter().apply { it in
            it.dateFormat = dateFormat
            it.timeZone = TimeZone.current
        })
    }
    
}
struct Utils {
    
    static func showToolTip(title: String,message:String){
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK" , style: .cancel, handler: { (_) in
            alert.dismiss(animated: true)
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
        
        rootViewController?.present(alert, animated: true)
    }
    static func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            
        }
    }
    
    static func openURL(url:String){
        if let url = URL(string: url),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func getGreetingsText() -> String {
      let hour = Calendar.current.component(.hour, from: Date())
      
      let NEW_DAY = 0
      let NOON = 12
      let SUNSET = 18
      let MIDNIGHT = 24
      
      var greetingText = "Hello!"
      switch hour {
      case NEW_DAY..<NOON:
          greetingText = "Good Morning!"
      case NOON..<SUNSET:
          greetingText = "Good Afternoon"
      case SUNSET..<MIDNIGHT:
          greetingText = "Good Evening!"
      default:
          _ = "Hello"
      }
      
      return greetingText
    }
}

func searchLocation(query:String,onResult:@escaping ([Address])->()){
    if(query.isEmpty){
        onResult([])
        return
    }
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    let search = MKLocalSearch(request: request)
    search.start { response, _ in
        guard let response = response else {
            onResult([])
            return
        }
        onResult(
            response.mapItems.map{
                Address(
                    lat: $0.placemark.coordinate.latitude,
                    lang: $0.placemark.coordinate.longitude,
                    name: "\($0.placemark.name ?? "-"), \($0.placemark.locality ?? "-")")
            }
        )
    }
}
