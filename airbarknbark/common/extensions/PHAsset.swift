//
//  PHAsset.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 22/09/2022.
//

import Foundation
import Photos
import UIKit
import RxSwift

extension PHAsset{
    func asUIImage(width:Int = 1280, height:Int = 850) -> Single<UIImage?>{
        .create { subscriber in
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions().apply { it in
                it.isSynchronous = false
                it.isNetworkAccessAllowed = true
                it.deliveryMode = .highQualityFormat
            }
            
            let requestId =  manager.requestImage(for: self, targetSize: .init(width: width , height: height), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                subscriber(.success(result))
            })
            
            return Disposables.create {
                manager.cancelImageRequest(requestId)
            }
        }
    }
}



