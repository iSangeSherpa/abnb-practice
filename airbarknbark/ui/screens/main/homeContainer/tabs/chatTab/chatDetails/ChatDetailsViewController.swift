//
//  ChatDetailsViewController.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation
import UIKit
import RxSwift
import Lightbox

class ChatDetailsViewController : ViewController<ChatDetailsView,ChatDetailsViewModel>{
    

    
    override func setupView() {
        
        binding.backButton.addOnClickListner {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.conversation
            .subscribe { [weak self]  it in
                self?.binding.avatarImage.loadImage(src: it?.otherUser.image,type: .User)
                self?.binding.verifiedCheck.isVisible = it?.otherUser.isProfileVerified() ?? false
                self?.binding.rightButton.isUserInteractionEnabled = it?.otherUser.showMyNumber ?? false
            }.disposed(by: disposeBag)
        
        viewModel.conversation.map{
            $0?.otherUser.fullName
        }.bind(to: binding.nameLabel.rx.text)
        .disposed(by: disposeBag)
        
        
        binding.messageTextField.rx.text.orEmpty.bind{ [unowned self] text in
            let maxHeight = 90.cgFloat
            let contentHeight = self.binding.messageTextField.contentSize.height
            self.binding.messageTextField.snp.updateConstraints { make in
                make.height.equalTo(contentHeight > maxHeight ? maxHeight : contentHeight)
            }
            self.viewModel.message.accept(text)
            
        }.disposed(by: disposeBag)
        
        viewModel.message.bind(to: binding.messageTextField.rx.text).disposed(by: disposeBag)
        
        viewModel.message.map{!$0.isEmpty}.bind(to: binding.messagePlaceholder.rx.isHidden).disposed(by: disposeBag)
        
        binding.sendButton.addOnClickListner {[unowned self] in
            self.viewModel.sendNewMessage()
        }
        
        binding.selectImageButton.rx.tapGesture()
            .when(.recognized)
            .flatMap { [unowned self] it in
                pickImages(max:1)
            }.map{
                $0.first
            }
            .filter { $0 != nil }
            .bind{[weak self] media in
                self?.binding.avatarImage.image = media
                guard let mediaImage = media else {return}
                self?.viewModel.sendNewMedia(media : mediaImage)
            }.disposed(by: disposeBag)
        
        bindChatMessages()
        
        binding.titleContainer.addOnClickListner {[unowned self] in
            guard let otherUser = self.viewModel.conversation.value?.otherUser else {return}
            if(otherUser.minderProfile == nil) {
                FinderProfileViewController().apply { [unowned self] it in
                    it.viewModel.finderUserId = otherUser.id
                    self.navigationController?.pushViewController(it, animated: true)
                }
            }
            else{
                MinderFullProfileViewController().apply {[unowned self] it in
                    it.viewModel.minderUserId = otherUser.id
                    self.navigationController?.pushViewController(it, animated: true)
                }
            }
        }
        binding.rightButton.addOnClickListner {[unowned self] in
            guard let otherUser = self.viewModel.conversation.value?.otherUser else {return}
            if(otherUser.showMyNumber ?? true){
                Utils.dialNumber(number: otherUser.phoneNumber ?? "")
            }
        }
      
        viewModel.getChatMessages()
    }
    
    
    private func bindChatMessages(){
        viewModel.chatMessageItems
            .bind(to: binding.chatTableView.rx.items(cellIdentifier: ChatTableViewCell.Identifier)){ [unowned self](row, item, cell)  in
                let cell = cell as! ChatTableViewCell
                cell.configure(model:item){
                    let controller = LightboxController(images: item.message.media.map{
                        LightboxImage(imageURL: URL(string: $0)!)
                         
                    })
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
        
        var lastItemCount = 0
        
        viewModel.chatMessageItems
            .filter{ $0.count > 0 }
            .delay(.milliseconds(10), scheduler: MainScheduler.asyncInstance)
            .bind { [unowned self] items in
                let indexPath = IndexPath(row: items.count - 1, section: 0)
                if(lastItemCount != 0 && lastItemCount != items.count ){
                    UIView.animate(withDuration: 0.4, delay: 0) { [self] in
                        binding.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }else{
                    binding.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                lastItemCount = items.count
            }.disposed(by: disposeBag)
        
        
        
        viewModel.onNewMessageReceived.bind{[unowned self]
            _ in
            
            if self.viewIfLoaded?.window != nil {
                self.viewModel.updateSeenStatus()
            }
           
        }.disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [unowned self] notification in
                keyboardWillBeVisible(notification as NSNotification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [unowned self] notification in
                keyboardWillBeHidden(notification as NSNotification)
            })
            .disposed(by: disposeBag)
    }
    
    func keyboardWillBeVisible(_ notification:NSNotification){
        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0

       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: animationCurve)!)

           binding.bottomActionButtons.snp.remakeConstraints { make in
               make.bottom.equalTo(view.safeAreaInsets).inset(keyboardSize.size.height + Dimension.SIZE_8.cgFloat)
               make.left.right.bottom.equalToSuperview()
           }

           let indexpath = IndexPath(row: binding.chatTableView.numberOfRows(inSection: 0) - 1, section: 0)

           UIView.animate(withDuration: animationDuration, delay: 0) { [self] in
               binding.layoutSubviews()
               if(indexpath.row >= 0){
                   binding.chatTableView.scrollToRow(at: indexpath, at:.bottom, animated: false)
               }
           }
       }
    }
    
    func keyboardWillBeHidden(_ notification:NSNotification){
        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0

        binding.bottomActionButtons.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets)
            make.left.right.bottom.equalToSuperview()
        }

        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: animationCurve)!)

        UIView.animate(withDuration: animationDuration, delay: 0) { [self] in
            binding.layoutSubviews()
        }

    }
    
}

extension ChatDetailsViewController{
    func forConversationId(conversationId:String) -> ChatDetailsViewController {
        return ChatDetailsViewController().apply { it in
            it.viewModel.conversationId = conversationId
        }
    }
}
