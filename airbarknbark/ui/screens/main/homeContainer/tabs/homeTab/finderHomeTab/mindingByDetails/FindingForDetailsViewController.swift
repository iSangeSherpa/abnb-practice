//
//  MinderDetailsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation
import RxSwift
import SDWebImage

class FindingForDetailsViewController : ViewController<FindingForDetailsView,FindingForDetailsViewModel>{
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
            self.parentController?.navigationController?.popViewController(animated: true)
            self.viewModel.triggerHomeRefresh.accept(Void())

        }.disposed(by: disposeBag)
        
//        binding.rightButton.rx.tapGesture()
//            .when(.recognized)
//            .flatMap { [self] it in
//                ReportAccountDialog.showReportAccountDialog(vc: self)
//            }.bind { [self] selectedReasons in
//                guard let message = selectedReasons.first else {return}
//                self.viewModel.reportAccount(message: message)
//            }.disposed(by: disposeBag)
        
        viewModel.isProfileVerified.bind{ isVerified in
            self.binding.idVerifiedButton.isHidden = !isVerified
        }.disposed(by: disposeBag)
        
        viewModel.userImage.bind{
            self.binding.imageView.loadImage(src: $0, type: .User)
        }.disposed(by: disposeBag)
        
        viewModel.name.bind(to: binding.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.rating.bind(to: binding.ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.experience.bind(to: binding.expLabel.rx.text).disposed(by: disposeBag)
        viewModel.address.bind(to: binding.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.phone.bind(to: binding.phoneLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.bookedFor.bind(to:binding.bookedDateLabel.rx.text).disposed(by: disposeBag)
        viewModel.time.bind(to:binding.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.bookedAddress.bind(to:binding.bookedAddress.rx.text).disposed(by: disposeBag)
        viewModel.totalPets.bind(to:binding.totalPetLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.startTime.bind(to:binding.clockInTimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.endTime.bind(to:binding.clockOutTimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.totalSessionPay.bind(to:binding.totalSessionPaymentLabel.rx.text).disposed(by: disposeBag)
        viewModel.remainingTime.bind(to:binding.timeRemainingLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.showMyNumber.bind{
            self.binding.dialerButton.isUserInteractionEnabled = $0
            if($0){
                self.binding.dialerButton.addOnClickListner {[unowned self] in
                    Utils.dialNumber(number: self.viewModel.phone.value)
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.showMyNumber.map{!$0}.bind(to: binding.phoneContainer.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.sessionCompleted.bind{
            if($0){
                self.binding.onGoingSessionButton.setTitle(" Completed Session", for: .normal)
                self.binding.timeRemainingTitleLabel.text = "Total time"
            }
        }.disposed(by: disposeBag)
        
        viewModel.isOvertime.bind{
            if(!self.viewModel.sessionCompleted.value && $0){
                self.binding.timeRemainingTitleLabel.text = "Overtime"
            }
        }.disposed(by: disposeBag)
        
        binding.sendMessageButton.addOnClickListner {[unowned self] in
            self.viewModel.startConversation()
        }
        
        viewModel.onConversationStart.bind{
            [weak self] conversationId in
            ChatDetailsViewController().forConversationId(conversationId: conversationId).apply({ it in
                self?.parentController?.navigationController?.pushViewController(it,animated: true)
            })
        }.disposed(by: disposeBag)
        
        binding.fullProfile.addOnClickListner {[unowned self] in
            MinderFullProfileViewController().apply {
                [weak self] it in
                guard let minderUserId = self?.viewModel.minderUserId else {return}
                it.viewModel.minderUserId = minderUserId
                self?.parentController?.navigationController?.pushViewController(it, animated: true)
            }
        }
        
        binding.rateMe.addOnClickListner {[unowned self] in
            RateMinderBottomSheetViewController().apply { it in
                guard let minderUserId = self.viewModel.minderUserId else {return}
                it.viewModel.minderUserId = minderUserId
                it.viewModel.requestId = self.viewModel.requestId
                self.present(it, animated: true)
            }.result().bind{
                self.viewModel.getReceivedMindingRequestDetails()
            }.disposed(by: self.disposeBag)
        }
        
        bindReviewsItems()
        
        viewModel.getReceivedMindingRequestDetails()
    }
    
    func bindReviewsItems(){
        viewModel.reviews.bind(to: binding.reviewsTableView.rx.items(cellIdentifier: ReviewsItemTableViewCell.Identifier)){(row, item, cell)  in
            let cell = cell as! ReviewsItemTableViewCell
            cell.configure(model:item)
        }.disposed(by: disposeBag)
        
        viewModel.reviews.delay(.milliseconds(500), scheduler: MainScheduler.instance).bind { [unowned self] items in
            UIView.animate(withDuration: 0.4) { [unowned self] in
                binding.reviewsTableView.snp.updateConstraints{ make in
                    make.height.equalTo(max(binding.reviewsTableView.contentSize.height, 32))
                }
                binding.layoutIfNeeded()
            }
            
        }.disposed(by: disposeBag)
    
        viewModel.reviews
            .map{  !$0.isEmpty  }
            .bind(to: binding.emptyReviewsLabel.rx.isHidden).disposed(by: disposeBag)
    }
    
    
    func result() -> Observable<Void>{
        return viewModel.triggerHomeRefresh.asObservable()
    }
    
}
