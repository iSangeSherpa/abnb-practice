//
//  ReviewsItemTableViewCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 14/11/2022.
//

import Foundation
import UIKit
import SDWebImage


class ReviewsItemTableViewCell : BaseUITableViewCell {
    
    var reviewImagesList:[String] = []
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(60).apply{ it in
        it.layer.cornerRadius = (60)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "Fluffy",font: .poppinsSemibold(fontSize: 16), alpha: 0.7)
    let reviewLabel = Caption(label: .VerifyOTP.desciption).apply {
        $0.textAlignment  = .left
        $0.font = .captionLight
    }
    let ratingLabel =  Caption(label: "4.7",font: .poppinsSemibold(fontSize: 14), alpha: 0.7).apply { it in
        it.numberOfLines = 1
    }
    
    let toLabel = Caption(label: "Tommy",font: .poppinsSemibold(fontSize: 14), alpha: 0.7).apply { it in
        it.numberOfLines = 1
    }
    lazy var mainContainer = stack(VSpacer(Dimension.SIZE_12),hstack(
        stack(VSpacer(12),avatarImage,UIView()),
        HSpacer(Dimension.SIZE_8),
        stack(
            VSpacer(Dimension.SIZE_4),
            hstack(nameLabel,
                   UIView(),
                   ratingLabel,
                   HSpacer(Dimension.SIZE_4),
                   UIImageView(icon: "ic_paw").withWidth(16)
                  ),
            hstack(reviewLabel,
                   UIView(),
                   Caption(label: "to").apply({ it in
                       it.textColor = .primary
                   }),
                   HSpacer(Dimension.SIZE_8),
                   toLabel
                  ),
            VSpacer(Dimension.SIZE_4),
            reviewImagesCollection
        )
        
    ),VSpacer(Dimension.SIZE_12)
    )
    
    let vDivider = VDivider()
    
    let layout = UICollectionViewFlowLayout().apply { it in
        it.scrollDirection = .horizontal
    }
    lazy var reviewImagesCollection = UICollectionView(frame: .zero,collectionViewLayout: layout)
    
    override func setupViews(){
        reviewImagesCollection.delegate = self
        reviewImagesCollection.dataSource = self
        reviewImagesCollection.register(ReviewsImagesItemCell.self, forCellWithReuseIdentifier: ReviewsImagesItemCell.Identifier)
        self.contentView.addSubViews(mainContainer, vDivider)
    }
   
    override func setupConstraints(){
        mainContainer.snp.makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-Dimension.SIZE_4.cgFloat)
        }
        
        vDivider.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.contentView )
        }
        reviewImagesCollection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    

    func configure(model : ReviewsItem){
        nameLabel.text = model.name
        reviewLabel.text = model.review
        ratingLabel.text = model.rating
        
        avatarImage.loadImage(src: model.avatarImage, type: .User)
        
        guard let images = model.images else{
            reviewImagesCollection.isHidden = true
            return
        }
        reviewImagesList = images
        reviewImagesCollection.isHidden = images.count == 0
        
        toLabel.apply { it in
            let attributedString = NSAttributedString(
                string: model.to,
                attributes: [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
            )
            it.attributedText = attributedString
        }
        
    }
}

extension ReviewsItemTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reviewImagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsImagesItemCell.Identifier, for: indexPath) as? ReviewsImagesItemCell
        else {
            return UICollectionViewCell()
        }
        
        cell.imageView.loadImage(src:reviewImagesList[indexPath.row], type: .Other)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: CGFloat(80))
    }
    
}

class ReviewsImagesItemCell : BaseUICollectionViewCell{
    
    let imageView =  UIImageView().apply {
        $0.contentMode = .scaleAspectFit
        //        $0.backgroundColor = .gray
    }
    
    override func setupViews() {
        addSubViews(imageView)
    }
    override func setupConstraints() {
        imageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}




