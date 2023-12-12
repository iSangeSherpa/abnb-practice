//
//  BookingDetailsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 07/11/2022.
//

import Foundation
import UIKit
import RxSwift
import SDWebImage


class FinderBookingDetailsViewController : ViewController<FinderBookingDetailsView,FinderBookingDetailsViewModel>{
    var parentController:HomeContainerScreenViewController? = nil
    
    override func setupView() {
        binding.backButton.addOnClickListner {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        let blockAccountAction = UIAction(title: "Block this Account", image: UIImage(systemName: "nosign")?.withTintColor(.red), attributes: [.destructive]) { (action) in
            BlockUnblockAccountDialog.showBlockUnblockAccountDialog(vc: self, message: .Dialog.blockAccountMessage,buttonText: .Dialog.blockAccountButtonText).subscribe(onSuccess: { _ in
                self.viewModel.blockAccount()
            }).disposed(by: self.disposeBag)
        }
        
        let reportAccountAction = UIAction(title: "Report this account", image: UIImage(named: "ic_warning")) { (action) in
            ReportAccountDialog.showReportAccountDialog(vc: self).subscribe(onSuccess: { selectedReasons  in
                guard let message = selectedReasons.first else {return}
                self.viewModel.reportAccount(message: message)
            }).disposed(by: self.disposeBag)
        }
        
        let menu = UIMenu(options: .displayInline, children: [blockAccountAction , reportAccountAction])
        
        binding.rightButton.menu = menu
        binding.rightButton.showsMenuAsPrimaryAction = true
        
        viewModel.onBlockUserSuccess.bind{
            self.viewModel.onBookingCancelled.accept(Void())
        }.disposed(by: disposeBag)
        
        binding.seeAllReviews.addOnClickListner {[unowned self] in
            self.parentController?.navigationController?.pushViewController( AllReviewsViewController(), animated: true)
        }
        viewModel.userImage.bind{
            self.binding.imageView.loadImage(src: $0,type: .User)
        }.disposed(by: disposeBag)
        
        viewModel.isProfileVerified.bind{ isVerified in
            self.binding.idVerifiedButton.isHidden = !isVerified
        }.disposed(by: disposeBag)
        
        viewModel.minderName.bind(to: binding.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.rating.bind(to:binding.ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.experience.bind(to:binding.expLabel.rx.text).disposed(by: disposeBag)
        viewModel.address.bind(to: binding.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.phone.bind(to: binding.phoneLabel.rx.text).disposed(by: disposeBag)
        viewModel.showMyNumber.map{!$0}.bind(to: binding.phoneContainer.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.bookedFor.bind(to:binding.bookedDateLabel.rx.text).disposed(by: disposeBag)
        viewModel.time.bind(to:binding.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.totalPay.bind(to:binding.totalPayLabel.rx.text).disposed(by: disposeBag)
        viewModel.totalPets.bind(to:binding.totalPetLabel.rx.text).disposed(by: disposeBag)
        viewModel.extraNotes.bind(to:binding.extraNotesLabel.rx.text).disposed(by: disposeBag)
        
        
        binding.cancelBookingButton.addOnClickListner {[unowned self] in
            self.viewModel.cancelBooking()
        }
        viewModel.onBookingCancelled.bind{
            self.parentController?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.status.bind{
            [weak self] status in
            guard let mindingRequestStatus = status else {return}
                self?.binding.requestStatusButton.apply({
                    $0.setTitle("Request \(mindingRequestStatus.getTitle())", for: .normal)
                    $0.layer.borderWidth = 2
                    $0.layer.borderColor = mindingRequestStatus.getColor().cgColor
                    $0.setTitleColor(mindingRequestStatus.getColor(), for: .normal)
                })
        }.disposed(by: disposeBag)
        
        bindSelectedPetItems()
        bindReviewsItems()
        viewModel.getSentMindingRequestDetails()
    }
    
    func bindSelectedPetItems(){
        
        viewModel.selectedPetItems.map{
            $0.enumerated().filter { index, _ in index<3 }.map { _, item in
                item
            }
        }
        .bind(to: binding.selectedPetsCollection.rx.items(cellIdentifier: SelectedPetsItemCell.Identifier)){  [self] (row, item, cell)  in
            let cell = cell as! SelectedPetsItemCell
            cell.configure(model:item)
            cell.rx.tapGesture().when(.recognized).bind{ _ in
                NewPetScreenViewController().apply { it in
                    it.disableEdit = true
                    it.viewModel.pet = item
                    self.present(it, animated: true)
                }
            }.disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        
        viewModel.selectedPetItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.selectedPetsCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.selectedPetsCollection.contentSize.height, 32))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
        
    }
    

    func bindReviewsItems(){
        viewModel.reviewsItems.bind(to: binding.reviewsTableView.rx.items(cellIdentifier: ReviewsItemTableViewCell.Identifier)){  [self] (row, item, cell)  in
            let cell = cell as! ReviewsItemTableViewCell
            cell.configure(model:item)
        }.disposed(by: disposeBag)
        
        viewModel.reviewsItems.delay(.milliseconds(500), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.reviewsTableView.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.reviewsTableView.contentSize.height, 32))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
        
        viewModel.reviewsItems
            .map{  !$0.isEmpty  }
            .bind(to: binding.emptyReviewsLabel.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.reviewsItems.map{
            $0.count<=3
        }.bind(to: binding.seeAllReviews.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func result() -> Observable<Void>{
        return self.viewModel.onBookingCancelled.asObservable()
    }
}
