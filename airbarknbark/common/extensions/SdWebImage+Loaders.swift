//
//  SdWebImage+Loaders.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/12/2022.
//

import Foundation 
import SDWebImage

enum ImageType{
    case User
    case Pet
    case Other
    
    func getPlaceHolderImage()->UIImage?{
        var name = ""
        
        switch(self){
        case .Other:
            name = "ic_image_placeholder.png"
            break
        case .User:
            name = "ic_user_placeholder.png"
            break
        case .Pet:
            name = "ic_pet_placeholder.png"
            break
        }
        
        return UIImage(named: name)
    }
}

extension UIImageView{
    func loadImage(src:String?, type:ImageType = .Other){
        
        guard let src = src else {
            self.image = type.getPlaceHolderImage()
            return
        }
        self.image = nil
        self.backgroundColor = .onBackground.withAlphaComponent(0.1)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: src), placeholderImage: nil, options: [.scaleDownLargeImages]) { (image, error, cacheType, url) in
            switch(error){
            case .none:
                self.image = image
                break;                
            case .some(_):
                self.image = type.getPlaceHolderImage()
            }
        }
    }
}
