//
//  RateMinderBottomSheetViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import RxSwift
import RxRelay

class RateFinderBottomSheetViewController : BottomSheetViewController<RateFinderView,RateFinderViewModel> {
    
    override var popupHeight: CGFloat {
        return 700
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPets()
        
        viewModel.initPets()
    }
    
    
    override func setupView() {
        binding.backButton.addOnClickListner {[unowned self] in
            self.viewModel.dismissBy.accept(Void())
        }
        
        binding.finderReviewInputField.textView.rx.text.orEmpty.bind(to: viewModel.finderReview).disposed(by: disposeBag)
        
        binding.finderStarRatingView.addRatingsChangeListener{[unowned self]
            ratings in
            self.viewModel.finderStarRatings.accept(ratings)
        }
        
        
        binding.submitReviewButton.addOnClickListner {[unowned self] in
            self.viewModel.submitReview()
        }
        
        
        viewModel.onReviewSubmitted.bind{[unowned self] in
            PopupDialogView.showPopupDialog(
                vc: self,
                title: .RatingsAndReviews.successTitle,
                body: .RatingsAndReviews.successBody
            ).subscribe(onSuccess: {[unowned self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.viewModel.dismissBy.accept(Void())
                }
            },onCompleted: {[unowned self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.viewModel.dismissBy.accept(Void())
                }
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        
        self.binding.petReviewInputField.textView.rx.text.bind{[unowned self] in
            self.viewModel.petReview.accept($0 ?? "")
        }.disposed(by: self.disposeBag)
        
        self.binding.petStarRatingView.addRatingsChangeListener{[unowned self] in
            self.viewModel.petStarRating.accept($0)
        }
        
        viewModel.petReviewTemp.bind(to: binding.petReviewInputField.textView.rx.text).disposed(by: disposeBag)
        
        viewModel.petStarRatingTemp.bind{[unowned self] in
            self.binding.petStarRatingView.setStarRating(starRatings: $0)
        }.disposed(by: disposeBag)
        
        self.viewModel.petImage.bind{[unowned self] in
            self.binding.petImage.loadImage(src: $0, type: .Pet )
        }.disposed(by: disposeBag)
        
       
    }
    
    func bindPets(){
        binding.petsCollection.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.petsReviews.bind(to: binding.petsCollection.rx.items(cellIdentifier: PetItemCell.Identifier)){  [unowned self] (row, item, cell)  in
            let cell = cell as! PetItemCell
            cell.configure(pet:item)
            cell.petNameButton.rx.tapGesture().when(.recognized)
                .map { it in item.item }
                .bind(to: viewModel.onPetClicked)
                .disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        
    }
    
    func result() -> Observable<Void>{
        return viewModel.onReviewSubmitted.asObservable()
    }
    
}

extension RateFinderBottomSheetViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemStringFrame = NSString(string:  viewModel.petsReviews.value[indexPath.row].item.petName)
        let estimatedFrame = itemStringFrame.boundingRect(with: CGSize(width: 1000, height: collectionView.frame.height),options: .usesLineFragmentOrigin,attributes: [NSAttributedString.Key.font: UIFont.poppinsMedium(fontSize: 20)], context: nil)
        return CGSize(width : estimatedFrame.width + 15, height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
