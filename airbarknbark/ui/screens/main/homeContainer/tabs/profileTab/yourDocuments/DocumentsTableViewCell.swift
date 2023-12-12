//
//  DocumentsItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/12/2022.
//

import Foundation
import Foundation
import UIKit
import RxSwift
import RxRelay

class DocumentsTableViewCell : BaseUITableViewCell{

    let docImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(50).apply{ it in
        it.layer.cornerRadius = (50)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let docTypeLabel = Caption(label: "Document Type",font:.captionSemiBold.withSize(12))
    let docNumberLabel = Caption(label: "Doc Number",font:.captionSemiBold.withSize(12))
    let issuedPlaceLabel = Caption(label: "Issued Place",font:.captionSemiBold.withSize(12))
    
    let arrowIcon =  UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
        it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 14))
        it.contentMode = .scaleAspectFit
    }
   
    lazy var topSection =
        hstack(
            docImage,
            HSpacer(Dimension.SIZE_16),
            stack(
                UIView(),
                hstack(docTypeLabel,
                       UIView(),
                       arrowIcon
                      ),
                VSpacer(Dimension.SIZE_8),
                hstack(docNumberLabel,UIView()),
                VSpacer(Dimension.SIZE_4),
                hstack(issuedPlaceLabel,UIView()),
                UIView(),
                distribution: .equalCentering
            )
        ).withMargins(UIEdgeInsets(vertical: Dimension.SIZE_22.cgFloat, horizontal: Dimension.SIZE_16.cgFloat)).apply { it in
            it.enableRipple().rippleView.apply{ it in
                it.layer.cornerRadius = 8
                it.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(-Dimension.SIZE_2)
                }
            }
        }
    
    let vDivider = VDivider()
    lazy var mainContainer = stack(
        VSpacer(Dimension.SIZE_12),
        stack(topSection,vDivider).apply { it in
                 it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
                 it.layer.borderWidth = 1
                 it.layer.cornerRadius = 8
                 it.backgroundColor = .white
             },
        VSpacer(Dimension.SIZE_12))
    
    override func setupViews(){
        self.contentView.addSubview(mainContainer)
    }
    
    override func setupConstraints(){
        mainContainer.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        vDivider.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimension.SIZE_8)
            make.right.equalToSuperview().offset(-Dimension.SIZE_8)
        }
    }
    
    func configure(model: DocumentDetails){
        self.docTypeLabel.text = model.type.description
        self.docNumberLabel.text = model.documentId
        self.issuedPlaceLabel.text = model.issuePlace
        self.docImage.loadImage(src: model.files?.first, type: .Other)
    }

}
