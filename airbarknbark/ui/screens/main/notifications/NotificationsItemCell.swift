//
//  NotificationsItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 18/11/2022.
//

import Foundation
import UIKit
import RxSwift


class NotificationsItemCell : BaseUITableViewCell{
   
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let notificationlabel = TitleH3(label: "John Doe").apply({ it in
        it.font = .poppinsMedium(fontSize: 15)
        it.numberOfLines = 2
    })

    let timeLabel = Caption(label: "10 July")
    
    let arrowImage  = UIImageView(image: UIImage(named: "ic_arrow_right")).withHeight(18).withWidth(12)
    
    lazy var mainContainer = hstack(
        stack(UIView(),avatarImage,UIView(),distribution: .equalCentering),
        HSpacer(Dimension.SIZE_16),
        stack(
            UIView(),
            stack(notificationlabel,VSpacer(Dimension.SIZE_4),hstack(timeLabel,UIView())),
            UIView(),
            distribution: .equalCentering
        ),
        stack(UIView(),arrowImage,UIView(),distribution: .equalCentering),
        spacing: Dimension.SIZE_2.cgFloat
    ).withMargins(UIEdgeInsets(vertical: Dimension.SIZE_12.cgFloat, horizontal: Dimension.SIZE_8.cgFloat)).apply { it in
        it.enableRipple()
        it.layer.cornerRadius = 5
    }
    
    lazy var cellContainer = stack(
        UIView(),
        mainContainer,
        UIView(),
        distribution: .equalCentering
    ).withMargins(.vertical(5))
    
    let vDivider = VDivider()
    
    
    override func setupViews() {
        self.contentView.addSubViews(cellContainer,vDivider)
    }
    
    override func setupConstraints() {
        cellContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vDivider.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }

    
    func configure(model : Notification){
        notificationlabel.text = model.text
        
        avatarImage.loadImage(src: model.image, type: .User)
        
        let elapsedTime = DateUtils.getElapsedTime(from: model.createdAt.asDateTime())
        
        let days : Int = abs((elapsedTime?.hr ?? 0) / 24)
        let hour : Int = abs(elapsedTime?.hr ?? 0)
        let min : Int = abs(elapsedTime?.min ?? 0)
        
        let timeText : String
        if(days != 0){
            timeText = "\(days) day\((days == 1) ? "":"s") ago"
        }else if(hour != 0){
            timeText = "\(hour) hour\((hour == 1) ? "":"s") ago"
        }else if(min != 0){
            timeText = "\(min) min\((min == 1) ? "":"s") ago"
        }else{
            timeText = "Just now"
        }
            
        timeLabel.text = timeText
        
        if(!model.isSeen){
            mainContainer.backgroundColor = UIColor(hexString: "#F3F3F3")
        }else{
            mainContainer.backgroundColor = .background
        }
    }
}
