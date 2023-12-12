//
//  UIViewController.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 16/09/2022.
//

import Foundation
import UIKit
import RxSwift
import BSImagePicker

extension UIViewController{
    
    
    func pickImageSource() -> Maybe<UIImagePickerController.SourceType>{
        return .create{ [self] maybe in
            let viewController = DialogViewController<ImageSourceDialogView,ViewModel>().setupBy { dialog in
                dialog.binding.crossButton.addOnClickListner {
                    maybe(.completed)
                }
                dialog.binding.cancelButton.addOnClickListner {
                    maybe(.completed)
                }
                dialog.binding.optionCamera.addOnClickListner {
                    dialog.dismiss(animated: true)
                    maybe(.success(.camera))
                }
                dialog.binding.optionGallery.addOnClickListner {
                    maybe(.success(.photoLibrary))
                }
            }
            present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }
    }
    
    
    func pickImagesFromGallery(max:Int = Int.max) -> Maybe<[UIImage]>{
        
        return Maybe.create{ [unowned self] maybe in
            
            let imagePicker = ImagePickerController()
            
            imagePicker.settings.selection.max = max
            
            self.presentImagePicker(imagePicker, animated: true) { asset in
                
            } deselect: { asset in
                
            } cancel: { assets in
                maybe(.completed)
            } finish: { assets in
                maybe(.success(assets))
            } completion: {
                
            }
            
            return Disposables.create {
                imagePicker.dismiss(animated: true)
            }
        }.asObservable()
            .flatMap {
                Observable.from($0)
            }.flatMap {
                $0.asUIImage()
                    .filter{ $0 != nil }
                    .map{ $0! }
                    .asObservable()
            }.toArray()
            .asMaybe()
        
    }
    
    func pickImageFromCamera() ->  Maybe<UIImage> {
        
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)){
            return .create{ maybe in
                maybe(.completed)
                
                return Disposables.create()
            }
        }
        
        return  UIImagePickerController.rx
            .createWithParent(self, animated: true) { controller in
                controller.sourceType = .camera
                controller.allowsEditing = false
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
            .asMaybe()
            .flatMap{ (info)  in
                guard let selectedImage = info[.originalImage] as? UIImage else {
                    
                    let emptyMaybe : Maybe<UIImage> = Maybe.create{ maybe in
                        maybe(.completed)
                        
                        return Disposables.create()
                    }
                    
                    return emptyMaybe
                }
                
                return Maybe.just(selectedImage)
                
            }
    }
    
    
    func pickImages(max:Int = Int.max) -> Maybe<[UIImage]>{
        pickImageSource()
            .flatMap { [unowned self] source in
                if(source == UIImagePickerController.SourceType.camera){
                    return pickImageFromCamera()
                        .map{ [$0] }
                }
                else{
                    return  pickImagesFromGallery(max: max)
                }
            }
    }
    
    
}
extension UIViewController {
    @discardableResult
    func alert(
        alertText : String,
        alertMessage : String,
        actions: [UIAlertAction],
        tint:UIColor
    ) ->UIAlertController{
        return UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert).apply { alert in
            actions.forEach { it in
                alert.addAction(it)
            }
            alert.view.tintColor = tint
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @discardableResult
    func alert(
        alertText : String,
        alertMessage : String,
        dismissMessage:String = .dismiss,
        handler: ((UIAlertAction)->Void)? = nil,
        tint:UIColor = .primary
    )->UIAlertController{
        let action = UIAlertAction(title: dismissMessage, style: UIAlertAction.Style.cancel, handler: handler)
        return alert(alertText: alertText, alertMessage: alertMessage, actions: [action], tint: tint)
    }
}



