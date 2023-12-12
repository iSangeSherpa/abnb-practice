//
//  NotificationView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 18/11/2022.
//

import Foundation
import UIKit

class NotificationsView : BaseUIView{
    
    let backButton  =  BackButton()
    
    let title = TitleH2(label: .Notifications.notifications)
    
    lazy var topStack = stack(
        hstack(
            backButton,
            UIView(),
            distribution: .fill
        ).withMargins(.horizontal(-Dimension.SIZE_8.cgFloat)),
        title,
        spacing: Dimension.SIZE_12.cgFloat,
        alignment: .leading
    )
    
    
    let notificationsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(NotificationsItemCell.self, forCellReuseIdentifier: NotificationsItemCell.Identifier)
    }
    lazy var emptyNotificationLabel = Caption(label: "No any notification").apply { it in
        it.isHidden = true
    }
    
    var markAllAsSeenView = stack(
        VSpacer(22),
        Caption(label: .Notifications.markAllAsSeen, font: .poppinsMedium(fontSize: 14)).apply({ it in
            it.textColor = .white
        }),
        spacing:Dimension.SIZE_2.cgFloat,
        alignment: .center
        
    ).withMargins(.horizontal(20))
    .withHeight(75)
    .apply { it in
        it.backgroundColor = .primary
        it.enableRipple().rippleView.layer.cornerRadius = 8
    }
        
    override func setupViews() {
        addSubViews(
            topStack,
            notificationsTableView,
            markAllAsSeenView,
            emptyNotificationLabel
        )
    }
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.top.equalTo(self.snp.topMargin).inset(Dimension.SCREEN_PADDING)
        }

        notificationsTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SIZE_16)
            make.top.equalTo(topStack.snp.bottom).offset(Dimension.SIZE_16)
            make.bottom.equalTo(markAllAsSeenView.snp.top).offset(Dimension.SIZE_16)
        }
        
        markAllAsSeenView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        emptyNotificationLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SIZE_16)
            make.centerY.equalToSuperview()
        }
    }
    
}
