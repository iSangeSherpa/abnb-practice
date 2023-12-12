//
//  YourPetsItemCell.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 16/11/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class YourPetsItemTableViewCell : BaseUITableViewCell{
    
    let avatarImage  = UIImageView(image: UIImage(named: "user_placeholder")).withSize(50).apply{ it in
        it.layer.cornerRadius = (50)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    let nameLabel = Caption(label: "Fluffy",font:.captionSemiBold.withSize(12))
    let ageLabel = Caption(label: "3 years old",font:.captionSemiBold.withSize(12))
    let breedLabel = Caption(label: "German Shepard",font:.captionSemiBold.withSize(12))
    
    let arrowIcon =  UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
        it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 14))
        it.contentMode = .scaleAspectFit
    }
    let immunizationStatusLabel = Caption(label: "Immunized",font:.captionSemiBold.withSize(12))
   
    lazy var topSection =
        hstack(
            avatarImage,
            HSpacer(Dimension.SIZE_16),
            stack(
                UIView(),
                hstack(nameLabel,
                       HSpacer(8),
                       HDivider(verticalMargin: 4, alpha: 1),
                       HSpacer(8),
                       ageLabel,
                       HSpacer(8),
                       HDivider(verticalMargin: 4, alpha: 1),
                       HSpacer(8),
                       breedLabel,
                       UIView(),
                       arrowIcon
                      ),
                VSpacer(Dimension.SIZE_8),
                hstack(
                    UIImageView(image: UIImage(named: "ic_circle_check")).withWidth(12).apply({ it in
                        it.contentMode = .scaleAspectFit
                    }),
                    HSpacer(8),
                    immunizationStatusLabel,
                    UIView()
                ),
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
    
    
    //MARK: Pet Information
    
    let layout  =  UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }

    let petNameField = OutlineInputField(label: .NewPet.petName)

    lazy var dateOfBirth = OutlineInputField(label: .NewPet.dateOfBirth, hint: .NewPet.dateOfBirthHint)

    let breedField = OutlineInputField(label:  .NewPet.chooseBreedType).apply { it in
        
        let trailingIcon = UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
            it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 16))
            it.contentMode = .scaleAspectFit
        }
        it.addTrailingView(view: trailingIcon)
    }

    let plusIcon = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
        it.contentMode = .scaleAspectFit
        it.withSize(62)
    }


    lazy var uploadPhotoView = UIView().apply { parent in
       
        let plusIcon1 = UIImageView(image: UIImage(named: "ic_circle_outline_plus")).apply { it in
            it.contentMode = .scaleAspectFit
            it.withSize(62)
        }
        
        let title = TitleH3(label:  .NewPet.uploadPetPhoto).apply { it in
            it.textAlignment = .left
        }
        
        let caption = Caption(label:  .NewPet.canUploadMoreThanOne).apply { it in
            it.textAlignment = .left
            it.font = .poppinsRegular(fontSize: 10)
        }
        
        parent.addSubViews(plusIcon, plusIcon1, title,caption)
        
        plusIcon.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SCREEN_PADDING)
            make.top.bottom.equalTo(parent)
        }
        
        plusIcon1.snp.makeConstraints { make in
            make.centerX.equalTo(plusIcon.snp.trailing).offset(-Dimension.SIZE_8)
            make.top.bottom.equalTo(parent)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(plusIcon1.snp.trailing).offset(Dimension.SCREEN_PADDING)
            make.trailing.equalTo(parent).offset(-Dimension.SCREEN_PADDING)
            make.centerY.equalTo(parent).offset(-Dimension.SIZE_8)
        }
        
        caption.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.top.equalTo(title.snp.bottom)
        }
        
        parent.enableRipple()
    }

    lazy var petsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply { table in
        table.showsHorizontalScrollIndicator  = false
        table.register(RemovableItemWithLabel.self)
    }

    lazy var petsContainer =  OutlineLabelOn(label: nil) { parent in
        
        parent.addSubViews(petsCollectionView, uploadPhotoView)
        
        petsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.allSides(Dimension.SIZE_16.cgFloat))
            make.height.equalTo(80)
        }
                
        uploadPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }

    let yesCheckBox  = CheckBoxWithLabel(label: .yes, checkedImage: "ic_yes_selected", uncheckdImage: "ic_yes_unselected")
    let noChecBox  = CheckBoxWithLabel(label: .no, checkedImage: "ic_no_selected", uncheckdImage: "ic_no_unselected")

    lazy var imunizationStatus = OutlineLabelOn(label: "Immunization Status") { parent in
        
        let stack = hstack(yesCheckBox.parent,noChecBox.parent, spacing: Dimension.SIZE_16.cgFloat, alignment: .center, distribution: .fillEqually)
        
        parent.addSubViews(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(parent).offset(Dimension.SIZE_22)
            make.trailing.equalTo(parent).offset(-Dimension.SIZE_22)
            make.top.equalTo(parent).offset(Dimension.SIZE_22)
            make.bottom.equalTo(parent).offset(-Dimension.SIZE_22)
        }
    }

    let behaviourField = OutlineInputField(label: .NewPet.behaviour, hint: .NewPet.selectBehaviour).apply { it in

        let trailingIcon = UIImageView( image: UIImage(named: "ic_drop_down")!).apply { it in
            it.frame = CGRect(origin: .zero, size:CGSize(width: 16, height: 16))
            it.contentMode = .scaleAspectFit
        }

        it.addTrailingView(view: trailingIcon)
    }

    lazy var petInformationStack = stack(
        VSpacer(Dimension.SIZE_8),
        petNameField,
        VSpacer(Dimension.SIZE_8),
        dateOfBirth,
        VSpacer(Dimension.SIZE_8),
        breedField,
        VSpacer(Dimension.SIZE_8),
        imunizationStatus,
        VSpacer(Dimension.SIZE_8),
        behaviourField,
        VSpacer(Dimension.SIZE_8),
        petsContainer,
        VSpacer(Dimension.SIZE_22),
        spacing: Dimension.SIZE_12.cgFloat
    ).withMargins(.horizontal(Dimension.SIZE_16.cgFloat))
    
    let vDivider = VDivider()
    lazy var mainContainer = stack(
        VSpacer(Dimension.SIZE_12),
        stack(topSection,
              vDivider,
              petInformationStack
             ).apply { it in
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
    
    func configure(model: PetDetails){
        petInformationStack.isHidden = true
        self.nameLabel.text = model.name
        self.ageLabel.text =   "\(model.dob.asYearDate().ageYears()) years old"
        self.breedLabel.text = model.breed?.name
        self.immunizationStatusLabel.text = model.immunizationStatus ? "Immunized" : "Not Immunized"
        self.avatarImage.loadImage(src: model.images.first, type: .Pet)
        
    }

    
}
