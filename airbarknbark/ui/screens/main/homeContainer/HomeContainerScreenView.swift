//
//  HomeContainerScreenView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit

class HomeContainerScreenView : BaseUIView{
    
    let bottomNavBar = hstack(
        alignment: .center,
        distribution: .equalSpacing
    )
    
    let contentView = UIView()
    
    override func setupViews() {
        addSubViews(bottomNavBar, contentView)
        bottomNavBar.layer.apply{ layer in
            layer.shadowColor = UIColor.onBackground.cgColor
            layer.cornerRadius = 10
            layer.shadowRadius = 10
            layer.shadowOpacity = 0.1
            layer.backgroundColor = UIColor.white.cgColor
            layer.shadowOffset = .init(width: 0, height: -5)
        }
        bottomNavBar.withMargins(.init(top: 22, left: 0, bottom: 15, right: 0))
        
    }
    
    override func setupConstraints() {
        bottomNavBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomNavBar.snp.top)
            make.topMargin.equalToSuperview()
        }
    }
    
    func newBottomNavItem(icon: String, label:String) -> BottomTabbarItem{
        let item = BottomTabbarItem(icon: icon, label: label)
        
        bottomNavBar.addArrangedSubview(item)
        
        let totalMenuItems = bottomNavBar.subviews.count
        
        bottomNavBar.subviews.forEach { it in
            it.snp.remakeConstraints { make in
                make.width.equalToSuperview().dividedBy(totalMenuItems)
            }
        }

        return item
    }
}

class BottomTabbarItem : BaseUIView {
        
    let icon = UIImageView().apply { it in
        it.contentMode = .scaleAspectFit
    }
    
    let label = UILabel().apply { it in
        it.font = .captionMedium
    }
    
    var isSelected :Bool = false{
        didSet{
            UIView.animate(withDuration: 0.05) { [self] in
                icon.alpha = isSelected ? 1 : 0.36
                label.alpha = isSelected ? 1 : 0.36
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init (icon: String, label:String){
        super.init(frame: .null)
        self.icon.image = UIImage(named: icon)
        self.label.text = label
    }
    
    override func setupViews() {
        addSubViews(icon, label)
        isSelected = false

        enableRipple(style: .unbounded).rippleView.apply({ it in
            it.maximumRadius = 50
        })
    }
    
    override func setupConstraints() {
        
        icon.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(Dimension.SIZE_4)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
