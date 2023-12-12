//
//  FinderProfileViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/12/2022.
//

import Foundation
import RxSwift
import Lightbox

class FinderProfileViewController : ViewController<FinderProfileView,FinderProfileViewModel>{
    
    override func setupView() {
        initListeners()
        
        viewModel.name.bind(to: binding.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.userImage.bind{
            self.binding.profileImageView.loadImage(src: $0,type: .User)
        }.disposed(by: disposeBag)
        viewModel.addressName.bind(to: binding.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.phone.bind(to: binding.phoneLabel.rx.text).disposed(by: disposeBag)
        viewModel.showMyNumber.map{!$0}.bind(to: binding.phoneContainer.rx.isHidden).disposed(by: disposeBag)
        viewModel.shortBio.bind(to: binding.shortBioLabel.rx.text).disposed(by: disposeBag)
        viewModel.locationDistance.bind(to: binding.locationDistance.rx.text).disposed(by: disposeBag)
        viewModel.rating.bind(to: binding.ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.user.bind(onNext: { [weak self] user in
            self?.binding.idVerifiedButton.isVisible = user?.isProfileVerified() ?? false
        }).disposed(by: disposeBag)
        bindReviews()
        bindPetDetials()
        viewModel.getFinderProfile()
    }
    
    func initListeners(){
        binding.backButton.addOnClickListner { [unowned self] in
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
        
    }
    
    func bindReviews(){
        viewModel.reviews.bind(to: binding.reviewsTableView.rx.items(cellIdentifier: ReviewsItemTableViewCell.Identifier)){ (row, item, cell)  in
            let cell = cell as! ReviewsItemTableViewCell
            cell.configure(model:item)
        }.disposed(by: disposeBag)
        
        viewModel.reviews.delay(.milliseconds(500), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyReviewsLabel.isHidden = (items.count != 0)
                binding.reviewsTableView.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.reviewsTableView.contentSize.height, 32))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
    }
    
    func bindPetDetials() {
        viewModel.petsDetails
            .bind(to: binding.petsTableView.rx.items(cellIdentifier: PetsWithAboutTableViewCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! PetsWithAboutTableViewCell
                cell.configure(model:item)
                
                cell.rx.tapGesture().when(.recognized).bind{ _ in
                    let controller = LightboxController(images: item.images.map{
                        LightboxImage(imageURL: URL(string: $0)!)
                    })
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }.disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        viewModel.petsDetails.delay(.milliseconds(500), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.petsTableView.snp.updateConstraints{ make in
                    binding.emptyPetsLabel.isHidden = (items.count != 0)
                    make.height.equalTo(max(binding.petsTableView.contentSize.height, 32))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
    }
    
}
