//
//  ChatDetailsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation
import UIKit

class ChatDetailsView : BaseUIView{
    
    let backButton = BackButton()
    let rightButton = BackButton().apply { it in
        it.setBackgroundImage(UIImage(named: "ic_dialer")?.withTintColor(.primary), for: .normal)
    }.withSize(25)
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(30).apply{ it in
        it.layer.cornerRadius = (30)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    
    lazy var verifiedCheck =  IdVerifiedButton()
    
    let nameLabel = TitleH3(label: "John Doe")
    
    lazy var titleContainer = hstack(
        avatarImage,
        HSpacer(Dimension.SIZE_8),
        nameLabel,
        HSpacer(Dimension.SIZE_4),
        verifiedCheck
    )
    
    lazy var topStack = hstack(
        stack(UIView(),backButton,UIView(),distribution: .equalCentering),
        titleContainer,
        UIView(),
        stack(UIView(),rightButton,UIView(),distribution: .equalCentering)
    ).padLeft(Dimension.SIZE_8.cgFloat)
        .padBottom(Dimension.SIZE_4.cgFloat).padRight(20)
    
    
    let chatTableView = UITableView().apply { (it:UITableView) in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.Identifier)
    }
    
    let selectImageButton =  BackButton().apply { it in
        it.setBackgroundImage(UIImage(named: "ic_camera")?.withTintColor(.black), for: .normal)
        it.layoutIfNeeded()
        it.subviews.first?.contentMode = .scaleAspectFit
    }.withSize(25)
    
    let sendButton =  BackButton().apply { it in
        it.setBackgroundImage(UIImage(named: "ic_send")?.withTintColor(.black), for: .normal)
        it.layoutIfNeeded()
        it.subviews.first?.contentMode = .scaleAspectFit
    }.withSize(25)
    
    let messagePlaceholder = Caption(label: "Type Message").apply { it in
        it.textColor =  UIColor(hexString:"#8C8C8C")
    }
    lazy var messageTextField = UITextView().apply { it in
        it.backgroundColor = .init(hexString: "#F2F2F2")
        it.font =  .poppinsMedium(fontSize: 14)
        it.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4)
    }.apply { it in
        it.addSubview(messagePlaceholder)
        messagePlaceholder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(5)
        }
    }
    
    
    
    lazy var bottomActionButtons = hstack(
        stack(UIView(),selectImageButton,UIView(),distribution: .equalCentering),
        messageTextField,
        stack(UIView(),sendButton,UIView(),distribution: .equalCentering),
        spacing: Dimension.SIZE_16.cgFloat
    ).withMargins(.horizontal(20)).padTop(Dimension.SIZE_22.cgFloat).apply { it in
        it.backgroundColor = .white
    }
    
    override func setupViews() {
        backgroundColor  = .background
        addSubViews(topStack,bottomActionButtons,chatTableView)
    }
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        messageTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        bottomActionButtons.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.bottom.equalTo(safeAreaInsets)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomActionButtons.snp.top)
        }
    }
}



