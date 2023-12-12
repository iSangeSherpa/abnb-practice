//
//  SdWebImageViewService.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/12/2022.
//

import Foundation
import UIKit
import SDWebImage


class SdWebImageService: AppService {
    
    func appDidStarted(application: UIApplication) {
       
        SDWebImageManager.shared.cacheKeyFilter = SDWebImageCacheKeyFilter { url in
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
           components?.query = nil

           return components?.url?.absoluteString ?? ""
        }
    }
}
