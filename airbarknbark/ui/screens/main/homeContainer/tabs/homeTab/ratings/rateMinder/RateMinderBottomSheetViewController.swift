//
//  RateMinderBottomSheetViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import UIKit
import RxSwift

class RateMinderBottomSheetViewController : BottomSheetViewController<RateMinderView,RateMinderViewModel>{
    
    override var popupHeight: CGFloat {
        return 500
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindImages()
    }
    
    override func setupView() {
        binding.backButton.addOnClickListner {[unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        
        binding.reviewInputField.textView.rx.text.orEmpty.bind(to: viewModel.review).disposed(by: disposeBag)
        
        binding.starRatingView.addRatingsChangeListener{
            ratings in
            self.viewModel.starRatings.accept(ratings)
        }
        
        binding.uploadPhotoView.rx.tapGesture()
            .when(.recognized)
            .map { it in }
            .bind(to: viewModel.newImageButtonClciked)
            .disposed(by: disposeBag)
        
        viewModel.newImageButtonClciked
            .flatMap { [self] it in
                pickImages(max: 5)
            }.map{[self] images in
                viewModel.images.value + images
            }
            .bind(to: viewModel.images)
            .disposed(by: disposeBag)
        
        binding.submitReviewButton.addOnClickListner {[unowned self] in
            self.viewModel.submitReview()
        }
     
        viewModel.onReviewSubmitted.bind{
            PopupDialogView.showPopupDialog(
                vc: self,
                title: .RatingsAndReviews.successTitle,
                body: .RatingsAndReviews.successBody
            ).subscribe(onSuccess: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.viewModel.dismissBy.accept(Void())
                }
            },onCompleted: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.viewModel.dismissBy.accept(Void())
                }
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
    }
    
    func bindImages(){
        viewModel.images
            .map {
                $0.isEmpty
                ? []
                : $0.map { item in
                    ItemOrNew.Item(item)
                } + [ItemOrNew.New]
            }
            .bind(to: binding.photosCollectionView.rx.items(cellIdentifier: RemovableItemWithLabel.Identifier)){  [self] (row, item, cell)  in
                
                let cell = cell as! RemovableItemWithLabel
                
                switch(item){
                case .Item(let image) :
                    cell.image.image = image
                    cell.label.isHidden = true
                    cell.image.layer.cornerRadius = 20
                    cell.image.clipsToBounds = true
                    cell.minusIcon.isHidden = false
                    cell.minusIcon.rx.tapGesture().when(.recognized)
                        .map { it in
                            image
                        }.bind(to:viewModel.removeImageButtonClick)
                        .disposed(by: cell.disposeBag)
                    break
                    
                case .New :
                    cell.image.image = UIImage(named: "ic_circle_outline_plus")
                    cell.label.text = "New Image"
                    cell.image.layer.cornerRadius = 0
                    cell.image.clipsToBounds = false
                    cell.label.isHidden = false
                    cell.minusIcon.isHidden = true
                    
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in }
                        .bind(to: viewModel.newImageButtonClciked)
                        .disposed(by: cell.disposeBag)
                    break
                }
            }.disposed(by: disposeBag)
        
        viewModel.images
            .map{  !$0.isEmpty  }
            .bind(to: binding.uploadPhotoView.rx.isHidden).disposed(by: disposeBag)
    }
    
    func result() -> Observable<Void>{
        return viewModel.onReviewSubmitted.asObservable()
    }
}
