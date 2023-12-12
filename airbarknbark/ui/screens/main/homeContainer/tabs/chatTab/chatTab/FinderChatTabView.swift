//
//  HomeTabView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit

class FinderChatTabView : BaseUIView{
    
    let title = TitleH2(label: "Conversation")
    
    let conversationLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    let refreshControl = UIRefreshControl()
    
    let conversationTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(ConversationItemCell.self, forCellReuseIdentifier: ConversationItemCell.Identifier)
    }
    
    lazy var containerStack = stack(
        title,
        conversationTableView,
        spacing: Dimension.SIZE_16.cgFloat
    )
    
    override func setupViews() {
        addSubview(containerStack)
        conversationTableView.addSubview(refreshControl)
    }
    
    override func setupConstraints() {
        containerStack.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(Dimension.SIZE_16)
            make.left.right.equalToSuperview().inset(Dimension.SIZE_16)
            make.bottom.equalToSuperview()
        }
    }
    
//    override func layoutSubviews() {
//        conversationLayout.itemSize = .init(width: Int(Float(conversationCollection.frame.width)), height: 90)
//    }
}
