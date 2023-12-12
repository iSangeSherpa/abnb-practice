//
//  ConversationItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation
import UIKit
import SDWebImage

class ConversationItemCell : BaseUITableViewCell{
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    
    let nameLabel = TitleH3(label: "John Doe")
    
    let timeLabel = Caption(label: "12:30 pm",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let newMessageIcon = PrimaryButton(label: "New", font: .poppinsMedium(fontSize: 10)).withSize(.init(width: 55, height: 28)).apply{ it in
        it.layer.cornerRadius = 0
    }
    
    let idVerifiedButton = IdVerifiedButton()
    
    lazy var idVerifiedWrapper =  hstack(idVerifiedButton,UIView())
    
    lazy var titleContainer = hstack(
        nameLabel,
        UIView(),
        timeLabel,
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    let messageLabel =  Caption(label: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer luctus mauris sit amet erat ornare tempor. In hac habitasse platea dictumst. Nullam condimentum bibendum scelerisque. ",font:.captionMedium.withSize(12)).apply{ it in
        it.alpha = 0.75
        it.numberOfLines = 2
        it.textAlignment = .left
        it.lineBreakMode = .byTruncatingTail
    }
    
    let vDivider = VDivider()
    lazy var cellView = hstack(
        HSpacer(1),
        avatarImage.withSize(60),
        stack(
            titleContainer.withHeight(20),
            VSpacer(2),
            idVerifiedWrapper,
            hstack(
                messageLabel,
                newMessageIcon,
                spacing: Dimension.SIZE_12.cgFloat,
                alignment:.center
            )
        ),
        HSpacer(4),
        spacing: Dimension.SIZE_12.cgFloat,
        alignment: .center
    ).withHeight(80).apply { it in
        it.enableRipple().rippleView.layer.cornerRadius = 4
        it.layer.cornerRadius = 8
        it.clipsToBounds = true
    }
    lazy var view = stack(UIView(),cellView,UIView())
    
    override func setupViews() {
        addSubViews(view,vDivider)
    }
    
    override func setupConstraints() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vDivider.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }

    func configure(item:ConversationWithLatestMessage){
        if(item.conversation.isInvalidated || item.lastMessage?.isInvalidated == true){
            return
        }
        nameLabel.text = item.conversation.otherUser.fullName ?? "Unamed User"
        if(item.lastMessage?.type == .NEW_MINDING_REQUEST){
            messageLabel.text = (item.lastMessage?.fromUserID == SessionManager.shared.userId) ?  "You sent \(item.conversation.otherUser.fullName ?? "") a request" :
            "\(item.conversation.otherUser.fullName ?? "") has sent you a request"
        }else{
            messageLabel.text =  item.lastMessage?.textRepresentation ?? "No Message"
        }
        timeLabel.text = item.lastMessage?.createdAt.asDateTime().asDisplayDateTimeString() ?? item.conversation.updatedAt.asDateTime().asDisplayDateTimeString()
        newMessageIcon.isHidden = true//item.lastMessage != nil
        
        avatarImage.loadImage(src: item.conversation.otherUser.image, type: .User)
        idVerifiedWrapper.isVisible = item.conversation.otherUser.isProfileVerified()
        
        
        cellView.backgroundColor = !(item.lastMessage?.isSeen ?? true) ? UIColor(hexString: "#F3F3F3") : .background
        
    }
    
    
}

