//
//  YourDocumentsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/12/2022.
//

import Foundation
import UIKit


class YourDocumentsView : BaseUIView{
    
    let backButton = BackButton()
    
    let titleText = TitleH1Bold(label: .YourDocuments.yourDocuments).apply {
        $0.textAlignment  = .left
    }
    
    let addNewLabel = UIButton().apply { it in
        
        it.titleLabel?.font = .poppinsRegular(fontSize: 14)
        
        let fullText = " + Add New "
        let attributedRange = NSString(string: fullText).range(of: "Add New", options: String.CompareOptions.caseInsensitive)
       
        let attributedText = NSMutableAttributedString.init(string:fullText)
        
        attributedText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue as Any],range: attributedRange)
        
        it.setAttributedTitle(attributedText, for: .normal)
        it.setAttributedTitle(attributedText,for: .selected)
        it.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_4.cgFloat
    }
    
    let yourDocumentsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(DocumentsTableViewCell.self, forCellReuseIdentifier: DocumentsTableViewCell.Identifier)
    }
    let saveButton  = PrimaryButton(label: .YourPets.saveChanges)
    
    override func setupViews() {
        addSubViews(backButton,titleText,addNewLabel,yourDocumentsTableView,saveButton)
    }
    
    override func setupConstraints() {
       
        backButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(Dimension.SIZE_8)
            make.top.equalToSuperview().offset(100)
        }
        
        titleText.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.top.equalTo(backButton.snp.bottom).offset(Dimension.SIZE_16)
        }
        
        addNewLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleText.snp.bottom)
            make.right.equalTo(self).offset(-Dimension.SCREEN_PADDING)
        }
        
        yourDocumentsTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimension.SCREEN_PADDING)
            make.right.equalToSuperview().offset(-Dimension.SCREEN_PADDING)
            make.top.equalTo(titleText.snp.bottom).offset(Dimension.SIZE_36)
            make.bottom.equalTo(saveButton.snp.top)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-35)
            make.left.equalToSuperview().offset(Dimension.SCREEN_PADDING)
            make.right.equalToSuperview().offset(-Dimension.SCREEN_PADDING)
        }
        
    }
    
}
