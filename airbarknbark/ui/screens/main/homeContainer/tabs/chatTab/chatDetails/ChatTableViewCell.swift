//
//  ChatMessageTableViewCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class ChatTableViewCell : BaseUITableViewCell {
  
    let messageLabel = UILabel().apply({ it in
        it.font = UIFont.poppinsRegular(fontSize: 14)
        it.textColor = UIColor(hexString: "#3C3C3C")
        it.numberOfLines = 0
    })
    
    let photoView =   UIImageView().apply { (it:UIImageView) in
        it.contentMode = .scaleAspectFill
        it.layer.cornerRadius = Dimension.SIZE_8.cgFloat
        it.clipsToBounds = true
        it.enableRipple()
    }
    
    let textContainer = UIView().apply ({ it in
        it.layer.cornerRadius = 10
    })
    
    override func setupViews(){
        self.contentView.addSubview(textContainer)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(photoView)
    }
    
    
    func setupUIForInfoMessage() {
        textContainer.backgroundColor = .surface
        messageLabel.textColor = .primary
        messageLabel.font = UIFont.poppinsBold(fontSize: 12)
        
        self.textContainer.snp.remakeConstraints { make in
            make.top.equalTo(self.contentView).offset(4)
            make.bottom.equalTo(self.contentView).offset(-4)
            make.centerX.equalTo(self.contentView)
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(textContainer).offset(4)
            make.bottom.equalTo(textContainer).offset(-4)
            make.left.equalTo(textContainer).offset(20)
            make.right.equalTo(textContainer).offset(-20)
        }
    }
    
    func setupUIForSelf() {
        textContainer.backgroundColor = .primary
        messageLabel.textColor = .white
        
        self.textContainer.snp.remakeConstraints { make in
            make.top.equalTo(self.contentView).offset(16)
            make.bottom.equalTo(self.contentView).offset(-16)
            make.right.equalTo(self.contentView).offset(-16)
            make.width.lessThanOrEqualTo(300)
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(textContainer).offset(12)
            make.bottom.equalTo(textContainer).offset(-12)
            make.left.equalTo(textContainer).offset(20)
            make.right.equalTo(textContainer).offset(-20)
        }
    }
    
    func setupUIForOthers() {
        textContainer.backgroundColor = UIColor.init(hexString: "F2F2F7")
        messageLabel.textColor = .black
        
        textContainer.snp.remakeConstraints { make in
            make.top.equalTo(self.contentView).offset(16)
            make.bottom.equalTo(self.contentView).offset(-16)
            make.left.equalTo(self.contentView).offset(16)
            make.width.lessThanOrEqualTo(300)
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(textContainer).offset(12)
            make.bottom.equalTo(textContainer).offset(-12)
            make.left.equalTo(textContainer).offset(20)
            make.right.equalTo(textContainer).offset(-20)
        }
    }
    
    func setViewTypeAsImage(messageContentType : MessageContentType, alignLeft:Bool){
        
        switch(messageContentType){
        case .Photo:
            if(alignLeft){
                photoView.snp.remakeConstraints{ make in
                    make.top.equalTo(self.contentView).offset(16)
                    make.bottom.equalTo(self.contentView).offset(-16)
                    make.left.equalTo(self.contentView).offset(16)
                }
                photoView.withSize(200)
            }else{
                photoView.snp.remakeConstraints { make in
                    make.top.equalTo(self.contentView).offset(16)
                    make.bottom.equalTo(self.contentView).offset(-16)
                    make.right.equalTo(self.contentView).offset(-16)
                }
                photoView.withSize(200)
            }
            
        case .Text:
            photoView.snp.removeConstraints()
        }
        
        photoView.isHidden = messageContentType == .Text
        textContainer.isHidden = messageContentType == .Photo
        messageLabel.isHidden = messageContentType == .Photo
    }
    let clickCallback : (()->Void)? = nil
    
    func configure(model : MessageWithOtherUser,  _ clickCallback : (()->Void)?){
       
        if(model.message.type == .NEW_MINDING_REQUEST){
            setupUIForInfoMessage()
            messageLabel.text = model.isSentbySelf ? "You sent \(model.otherUser.fullName ?? "") a request" :
            "\(model.otherUser.fullName ?? "") has sent you a request"
            return
        }
        if(model.isSentbySelf) {
            setupUIForSelf()
        }else{
            setupUIForOthers()
        }
        
        if(model.message.text != nil){
            messageLabel.text = model.message.text
        }else if(model.message.media.count>0){
            photoView.loadImage(src:model.message.media.first, type: .Other)
            photoView.addOnClickListner {
                clickCallback?()
            }
        }
        
        setViewTypeAsImage(messageContentType: model.contentType , alignLeft: !model.isSentbySelf)
    }
}
