//
//  activeProfileToggleView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/01/2023.
//

import Foundation
import UIKit

class ActiveProfileToggleView : BaseUIView{

    var valueChangeListener : ((ActiveProfile)->())? = nil
    var onItemClickListener : ((ActiveProfile)->())? = nil
    
    var activeProfile : ActiveProfile = .FINDER{
        didSet{
            resetToggleSelection()
            switch(activeProfile){
            case .MINDER:
                minderTitleLabel.textColor = .white
                minderIconImageView.tintColor = .white
                minderToggleItem.backgroundColor = .primary
            case .FINDER:
                finderTitleLabel.textColor = .white
                finderIconImageView.tintColor = .white
                finderToggleItem.backgroundColor = .primary
            case .BOTH:
                bothTitleLabel.textColor = .white
                bothIconImageView.tintColor = .white
                bothToggleItem.backgroundColor = .primary
            }
            
            self.valueChangeListener?(activeProfile)
            
            func resetToggleSelection(){
                minderTitleLabel.textColor = .black
                minderIconImageView.tintColor = .black
                minderToggleItem.backgroundColor = .white
                
                finderTitleLabel.textColor = .black
                finderIconImageView.tintColor = .black
                finderToggleItem.backgroundColor = .white
                
                bothTitleLabel.textColor = .black
                bothIconImageView.tintColor = .black
                bothToggleItem.backgroundColor = .white
            }
        }
    }
    
    //MINDER
    lazy var minderIconImageView = UIImageView(image: UIImage(named: "ic_tab_profile")?.withRenderingMode(.alwaysTemplate)).withSize(12)
    lazy var minderTitleLabel =  Caption(label: "Minder")
    
    
    lazy var minderToggleItem =  hstack(
        HSpacer(Dimension.SIZE_4),
        minderIconImageView,
        minderTitleLabel,
        HSpacer(Dimension.SIZE_4),
        spacing:Dimension.SIZE_4.cgFloat,
        alignment: .center
    ).withHeight(30)
    .apply { it in
        it.layer.cornerRadius = 5
        it.backgroundColor = activeProfile == .BOTH ? .primary : .surface
        it.enableRipple().rippleView.layer.cornerRadius = 4
    }
    
    //FINDER
    lazy var finderIconImageView = UIImageView(image: UIImage(named: "ic_location_person")?.withRenderingMode(.alwaysTemplate)).withHeight(12).withWidth(10)
    lazy var finderTitleLabel = Caption(label: "Finder")
    
    lazy var finderToggleItem =  hstack(
        HSpacer(Dimension.SIZE_4),
        finderIconImageView,
        finderTitleLabel,
        HSpacer(Dimension.SIZE_4),
        spacing:Dimension.SIZE_4.cgFloat,
        alignment: .center
    ).withHeight(30)
    .apply { it in
        it.layer.cornerRadius = 5
        it.backgroundColor = activeProfile == .BOTH ? .primary : .surface
        it.enableRipple().rippleView.layer.cornerRadius = 4
    }
    
    //BOTH
    lazy var bothIconImageView = UIImageView(image: UIImage(named: "ic_profile_both")?.withRenderingMode(.alwaysTemplate)).withSize(12)
    lazy var bothTitleLabel = Caption(label: "Both")
    
    lazy var bothToggleItem =  hstack(
        HSpacer(Dimension.SIZE_4),
        bothIconImageView,
        bothTitleLabel,
        HSpacer(Dimension.SIZE_4),
        spacing:Dimension.SIZE_4.cgFloat,
        alignment: .center
    ).withHeight(30)
    .apply { it in
        it.layer.cornerRadius = 5
        it.backgroundColor = activeProfile == .BOTH ? .primary : .surface
        it.enableRipple().rippleView.layer.cornerRadius = 4
    }
    
    lazy var activeProfileToggleView = hstack(
        minderToggleItem,
        finderToggleItem,
        bothToggleItem,
        spacing: Dimension.SIZE_4.cgFloat
    ).withMargins(.init(vertical: Dimension.SIZE_8.cgFloat, horizontal: Dimension.SIZE_8.cgFloat)).apply { it in
        it.layer.borderColor = UIColor.black.withAlphaComponent(0.09).cgColor
        it.layer.borderWidth = 2
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
   override func setupViews() {
        self.addSubview(activeProfileToggleView)
       
       minderToggleItem.addOnClickListner {[unowned self] in
           self.activeProfile = .MINDER
           self.onItemClickListener?(.MINDER)
       }
       finderToggleItem.addOnClickListner {[unowned self] in
           self.activeProfile = .FINDER
           self.onItemClickListener?(.FINDER)
       }
       
       bothToggleItem.addOnClickListner {[unowned self] in
           self.activeProfile = .BOTH
           self.onItemClickListener?(.BOTH)
       }
    }
    
   override func setupConstraints() {
       self.activeProfileToggleView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }
   }
    
    func addOnValueChangeListener(valueChangeListener : ((ActiveProfile)->())? = nil){
        self.valueChangeListener = valueChangeListener
    }
    
    func addOnItemClickListener(onItemClickListener : ((ActiveProfile)->())? = nil){
        self.onItemClickListener = onItemClickListener
    }
}
