//
//  PetItemTableViewCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 09/12/2022.
//

import Foundation
import UIKit

class PetItemCell : BaseUICollectionViewCell{
    
    let petNameButton = PrimaryButton(label: "")
    
    
    override func setupViews() {
        addSubview(petNameButton)
    }
    override func setupConstraints() {
        petNameButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(pet : Selectable<PetReviewModel>){
        self.petNameButton.setTitle(pet.item.petName, for: .normal)
        
        self.petNameButton.backgroundColor = pet.isSelected ? .primary : UIColor(hexString: "#E9E9E9")
        self.petNameButton.configuration?.baseBackgroundColor = pet.isSelected ? .primary : UIColor(hexString: "#E9E9E9")
        
        self.petNameButton.setTitleColor(pet.isSelected ? .white : UIColor(hexString: "#5F5F5F"), for: .normal)
    }
}



