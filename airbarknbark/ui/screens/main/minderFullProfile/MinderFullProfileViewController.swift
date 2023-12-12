//
//  MinderFullProfileViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 11/11/2022.
//

import Foundation
import UIKit
import RxSwift
import SDWebImage
import Lightbox

class MinderFullProfileViewController : ViewController<MinderFullProfileView,MinderFullProfileViewModel>{
    
    override func setupView() {
        
        binding.availabilityContainer.isHidden = true
        
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
        
        viewModel.name.bind(to: binding.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.userImage.bind{
            self.binding.profileImageView.loadImage(src: $0,type: .User)
        }.disposed(by: disposeBag)
        viewModel.addressName.bind(to: binding.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.phone.bind(to: binding.phoneLabel.rx.text).disposed(by: disposeBag)
        viewModel.showMyNumber.map{!$0}.bind(to: binding.phoneContainer.rx.isHidden).disposed(by: disposeBag)
        viewModel.shortBio.bind(to: binding.shortBioLabel.rx.text).disposed(by: disposeBag)
        viewModel.yearsOfExpereince.bind(to: binding.experienceLabel.rx.text).disposed(by: disposeBag)
        viewModel.rate.bind(to: binding.chargesLabel.rx.text).disposed(by: disposeBag)
        viewModel.locationDistance.bind(to: binding.locationDistance.rx.text).disposed(by: disposeBag)
        
        viewModel.rating.bind(to: binding.ratingLabel.rx.text).disposed(by: disposeBag)
        
        bindAvailabilityDays()
        
        bindBreedItems()
        bindPetBehaviourItems()
        bindReviewsItems()
        bindPetDetials()
        
        binding.breedsCollection.rx.setDelegate(self).disposed(by: disposeBag)
        binding.petBehaviourCollection.rx.setDelegate(self).disposed(by: disposeBag)
        
        initListeners()
        
        viewModel.getMinderProfile()
        
        viewModel.dogSize.bind{
            self.resetDogSize()
            for size in $0{
                self.setDogSize(dogSize: size)
            }
        }.disposed(by: disposeBag)
        
        binding.sendMessageButton.addOnClickListner {[unowned self] in
            self.viewModel.startConversation()
        }
        viewModel.onConversationStart.bind{
            [weak self] conversationId in
            ChatDetailsViewController().forConversationId(conversationId: conversationId).apply({ it in
                self?.navigationController?.pushViewController(it,animated: true)
            })
        }.disposed(by: disposeBag)
        
        viewModel.userDetails.bind(onNext: { [weak self] user in
            self?.binding.idVerifiedButton.isVisible = user?.isProfileVerified() ?? false
        }).disposed(by: disposeBag)
     
    }
    
    func initListeners(){
        binding.createRequestButton.addOnClickListner { [unowned self] in
            self.viewModel.onCreateRequestClicked.accept(Void())
        }
        viewModel.onCreateRequestClicked.flatMap { _ in
            return  CreateRequestViewController().apply { [self] it in
                it.viewModel.minderUserId = self.viewModel.minderUserId
                self.present(it, animated: true)
            }.result()
        }
        .bind { [self] it in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.alert("Request Sent") //TODO:
            }
        }.disposed(by: disposeBag)
    }
    
    func setDogSize(dogSize: PetSizePreferences){
        switch(dogSize){
        case .SMALL :
            self.binding.dogSizeSmall.layer.opacity = 1
            self.binding.dogSizeSmall.layer.borderWidth = 1
          
        case .MEDIUM :
            self.binding.dogSizeMedium.layer.opacity = 1
            self.binding.dogSizeMedium.layer.borderWidth = 1
        
        case .LARGE :
            self.binding.dogSizeLarge.layer.opacity = 1
            self.binding.dogSizeLarge.layer.borderWidth = 1
            
        }
    }
    
    func resetDogSize(){
        self.binding.dogSizeSmall.layer.opacity = 0.3
        self.binding.dogSizeMedium.layer.opacity = 0.3
        self.binding.dogSizeLarge.layer.opacity = 0.3
        
        self.binding.dogSizeSmall.layer.borderWidth = 0
        self.binding.dogSizeMedium.layer.borderWidth = 0
        self.binding.dogSizeLarge.layer.borderWidth = 0
    }
    
    func bindAvailabilityDays(){
        viewModel.availabilityDaysItems
            .bind(to: binding.availabilityDaysCollection.rx.items(cellIdentifier: AvailabilityDaysItemCell.Identifier)){  [self] (row, item, cell)  in
                
                let cell = cell as! AvailabilityDaysItemCell
                cell.configure(model: item)
                if(item.item.isAvailable){
                    cell.rx.tapGesture().when(.recognized)
                        .map { it in item }
                        .bind{
                            self.viewModel.dayClicked.accept(item)
                            if(!item.isSelected){
                                self.viewModel.availabilityTime.accept(item.item)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                }
                
            }.disposed(by: disposeBag)
        
        viewModel.availabilityDaysItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyAvailabilityLabel.isHidden = (items.count != 0)
                binding.availabilityDaysCollection.snp.updateConstraints{ make in
                    make.height.equalTo((items.count == 0) ? 32 : 100)
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
        
        viewModel.availabilityDaysItems.map {
            $0.filter { items in
                items.isSelected
            }}.map {
                $0.count==0
            }.bind(to: binding.availabilityTimeContainer.rx.isHidden)
                .disposed(by: disposeBag)
        
        
        viewModel.availabilityTime.bind{
            guard let from = $0?.from ,let to = $0?.to else {return}
            self.binding.availabilityTimeLabel.text = "From \(from) to \(to)"
        }.disposed(by: disposeBag)
        
    }
    
    func bindBreedItems(){
        viewModel.breedItems
            .bind(to: binding.breedsCollection.rx.items(cellIdentifier: MinderFullProfileView.FlowLabelItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MinderFullProfileView.FlowLabelItemCell
                cell.itemLabel.text = item
            }.disposed(by: disposeBag)
        
        
        viewModel.breedItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyBreedsLabel.isHidden = (items.count != 0)
                binding.breedsCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.breedsCollection.contentSize.height, 10))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
        
       
    }
    
    func bindPetBehaviourItems(){
        viewModel.petBehaviourItems
            .bind(to: binding.petBehaviourCollection.rx.items(cellIdentifier: MinderFullProfileView.FlowLabelItemCell.Identifier)){  [self] (row, item, cell)  in
                let cell = cell as! MinderFullProfileView.FlowLabelItemCell
                cell.itemLabel.text = item
            }.disposed(by: disposeBag)
        
        viewModel.petBehaviourItems.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.emptyPetBehaviour.isHidden = (items.count != 0)
                binding.petBehaviourCollection.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.petBehaviourCollection.contentSize.height, 10))
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

extension MinderFullProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemStringFrame : NSString
        if(collectionView == self.binding.breedsCollection){
            itemStringFrame =  NSString(string:  viewModel.breedItems.value[indexPath.row])
        }else if(collectionView == self.binding.petBehaviourCollection){
            itemStringFrame = NSString(string:  viewModel.petBehaviourItems.value[indexPath.row])
        }
        else { return .zero}
      
        let estimatedFrame = itemStringFrame.boundingRect(with: CGSize(width: 1000, height: 20),options: .usesLineFragmentOrigin,attributes: [NSAttributedString.Key.font: UIFont.poppinsMedium(fontSize: 16)], context: nil)
        return CGSize(width : max(estimatedFrame.width + 10,50), height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
