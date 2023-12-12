//
//  MinderFullProfileView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 11/11/2022.
//

import Foundation
import UIKit

class MinderFullProfileView : BaseUIView{
    let topPadding = Dimension.SIZE_46.cgFloat
    
    let backButton = BackButton()
    let rightButton = UIButton().apply { it in
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.65)
        it.contentMode = .center
        it.setBackgroundImage(UIImage(named: "ic_ellipsis"), for: .normal)
    }
    
    lazy var topStack = hstack(backButton,UIView(),rightButton).padTop(topPadding).padLeft(-Dimension.SIZE_8.cgFloat)
    
    let scrollView  = UIScrollView().apply { it in
        it.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let idVerifiedButton = IdVerifiedButton()
    
    lazy var profileImageView = UIImageView(image: UIImage(named: "user_placeholder")).withSize(90).apply { it in
        it.layer.borderWidth = 3
        it.layer.borderColor = UIColor.background.cgColor
        it.layer.cornerRadius = (90)/2
        it.clipsToBounds = true
        it.contentMode = .scaleAspectFill
    }
    
    let nameLabel = TitleH3(label: "")
    
    lazy var titleContainer = stack(
        nameLabel,
        idVerifiedButton,
        spacing: Dimension.SIZE_2.cgFloat,
        alignment: .center
    )
    
    let addressLabel = Caption(label: "",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
    let phoneLabel = Caption(label: "",font: .poppinsMedium(fontSize: 12),alpha: 0.8)
    lazy var phoneContainer = hstack(UIImageView(icon: "ic_dialer_outline", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
                                phoneLabel)
    lazy var locationWithContacts = hstack(
//        UIImageView(icon: "ic_location", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
//        addressLabel,
//        HDivider(verticalMargin: 8),
        phoneContainer,
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    let chargesLabel = TitleH3(label: "$40/hr")
    
    lazy var chargesView = stack(
        UIView().withSize(55).apply { it in
            it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
            it.layer.borderWidth = 1
            it.layer.cornerRadius = 5
            let imageView = UIImageView(icon: "ic_wallet").withSize(12)
            it.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
            }
        },
        VSpacer(Dimension.SIZE_8),
        chargesLabel,
        Caption(label: "Charges",font: .poppinsMedium(fontSize: 12),alpha: 0.8),
        alignment: .center
    )
    
    let experienceLabel = TitleH3(label: "1 year")
    
    lazy var experienceView = stack(
        UIView().withSize(55).apply { it in
            it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
            it.layer.borderWidth = 1
            it.layer.cornerRadius = 5
            let imageView = UIImageView(icon: "ic_briefcase",tint: UIColor(hexString: "#4E71A7")).withSize(12)
            it.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
            }
        },
        VSpacer(Dimension.SIZE_8),
        experienceLabel,
        Caption(label: "Experiences",font: .poppinsMedium(fontSize: 12),alpha: 0.8).apply({ it in
            it.numberOfLines = 1
        }),
        alignment: .center
    )
    
    let ratingLabel = TitleH3(label: "4.5 stars")
    
    lazy var ratingView = stack(
        UIView().withSize(55).apply { it in
            it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
            it.layer.borderWidth = 1
            it.layer.cornerRadius = 5
            let imageView = UIImageView(icon: "ic_paw").withSize(12)
            it.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
            }
            
        },
        VSpacer(Dimension.SIZE_8),
        ratingLabel,
        Caption(label: "Rating",font: .poppinsMedium(fontSize: 12),alpha: 0.8),
        alignment: .center
    )
    
    lazy var statContainer = hstack(chargesView,UIView(),experienceView,UIView(),ratingView,distribution: .equalCentering)
    
    let locationDistance = Caption(label: "2.3 km away from you",font:.poppinsMedium(fontSize: 12)).apply{ it in
        it.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    lazy var pathDistanceContainer = hstack(
        UIImageView(image: UIImage(named: "ic_path_distance")).withWidth(16).apply({ it in
            it.contentMode = .scaleAspectFit }),
        HSpacer(Dimension.SIZE_8),
        locationDistance
    ).withMargins(.init(vertical: 5, horizontal: 10))
        .apply { it in
            it.backgroundColor = UIColor(hexString: "#F4F4F4")
            it.layer.cornerRadius = 4
        }
    
    let shortBioLabel =  Caption(label: "Working and traveling throughout Australia in my  toyota campervan with my dog (Freddie). Been on the road for 4 months and am an experienced dog owner and dog sitter.  Love all dogs and have always had a furry friend by my side. ",font: .poppinsRegular(fontSize: 14), alpha: 0.8).apply { it in
        it.textAlignment = .left
    }
    
    lazy var shortBioContainer = stack(
        TitleH3(label: "Short bio"),
        VSpacer(Dimension.SIZE_8),
        shortBioLabel
        
    ).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }.withMargins(.init(vertical: 20, horizontal: 20))
    
    lazy var emptyPetsLabel = Caption(label: .MinderFullProfile.noPets).apply { it in
        it.isHidden = true
    }
    
    let petsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(PetsWithAboutTableViewCell.self, forCellReuseIdentifier: PetsWithAboutTableViewCell.Identifier)
    }

    
    lazy var selectedPetsView = stack(
        VSpacer(Dimension.SIZE_22),
        hstack(TitleH3(label: "Pets"),UIView()),
        VSpacer(Dimension.SIZE_22),
        emptyPetsLabel,
        petsTableView,
        VSpacer(Dimension.SIZE_22)
    ).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
        
        petsTableView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }
    
    
    
    let availabilityDaysLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var availabilityDaysCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: availabilityDaysLayout
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(AvailabilityDaysItemCell.self)
    }
    
    let availabilityTimeLabel = Caption(label: "From 11:00 am to 3:00 pm",font:.poppinsMedium(fontSize: 14))
   
    lazy var emptyAvailabilityLabel = Caption(label: "No data").apply { it in
        it.isHidden = true
    }
    
    lazy var availabilityTimeContainer = hstack(
        UIView(),
        hstack(HSpacer(Dimension.SIZE_22),availabilityTimeLabel,HSpacer(Dimension.SIZE_22)).apply ({ it in
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
            it.backgroundColor = UIColor(hexString: "#F4F4F4")
            it.layer.cornerRadius = 4
        }).withHeight(40),
        UIView(),
        distribution: .equalCentering)
    
    lazy var availabilityContainer = stack(
        hstack(TitleH3(label: "Availability"),
               Caption(label: "(Click to Check)",font: .poppinsRegular(fontSize: 12)),
               UIView()),
        VSpacer(Dimension.SIZE_8),
        availabilityDaysCollection,
        emptyAvailabilityLabel,
        VSpacer(Dimension.SIZE_22),
        availabilityTimeContainer
    ).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
      
    }.withMargins(.init(vertical: 20, horizontal: 20))
    
    let dogSizeSmall = stack(
        UIView().withSize(80).apply({ it in
            let imageView = UIImageView(image: UIImage(named: "ic_dog_small"))
            it.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(30)
                make.bottom.equalToSuperview().offset(-30)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }),
        Caption(label: "Small dog\n(0-15 lbs)",font:.poppinsMedium(fontSize: 12)).apply{ it in
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    ).withMargins(.allSides(10)).apply { it in
        it.layer.borderColor = UIColor.primary.cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    let dogSizeMedium =  stack(
        UIView().withSize(80).apply({ it in
            let imageView = UIImageView(image: UIImage(named: "ic_dog_medium"))
            it.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(25)
                make.bottom.equalToSuperview().offset(-25)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }) ,
        Caption(label: "Medium dog\n(16-40 lbs)",font:.poppinsMedium(fontSize: 12)).apply{ it in
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    ).withMargins(.allSides(10)).apply { it in
        it.layer.borderColor = UIColor.primary.cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    let dogSizeLarge =  stack(
        UIView().withSize(80).apply({ it in
            let imageView = UIImageView(image: UIImage(named: "ic_dog_large"))
            it.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(25)
                make.bottom.equalToSuperview().offset(-25)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }) ,
        Caption(label: "Large dog\n(41-100 lbs)",font:.poppinsMedium(fontSize: 12)).apply{ it in
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    ).withMargins(.allSides(10)).apply { it in
        it.layer.borderColor = UIColor.primary.cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    lazy var dogSizeStack = hstack(
        dogSizeSmall,
        stack(UIView(),HDivider(alpha: 0.5).withHeight(50),UIView(),distribution: .equalCentering),
        dogSizeMedium,
        stack(UIView(),HDivider(alpha: 0.5).withHeight(50),UIView(),distribution: .equalCentering),
        dogSizeLarge,
        distribution: .equalCentering)
    
    
    lazy var breedsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomViewFlowLayout()
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(FlowLabelItemCell.self)
    }
    
    lazy var emptyBreedsLabel = Caption(label: " No breed preference").apply { it in
        it.isHidden = true
        it.textAlignment = .left
    }
    
    lazy var breedsContainer = stack(
        VSpacer(Dimension.SIZE_16),
        hstack(TitleH3(label: "Breeds"),
               UIView()),
        VSpacer(8),
        breedsCollection,
        emptyBreedsLabel,
        VSpacer(Dimension.SIZE_8)
    )
    lazy var emptyPetBehaviour = Caption(label: " No pet behaviour").apply { it in
        it.isHidden = true
        it.textAlignment = .left
    }
    
    lazy var petBehaviourCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomViewFlowLayout()
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(FlowLabelItemCell.self)
    }
    
    lazy var petBehaviourContainer = stack(
        VSpacer(Dimension.SIZE_16),
        hstack(TitleH3(label: .MinderProfileSetup.petBehaviour),
               UIView()),
        VSpacer(Dimension.SIZE_8),
        petBehaviourCollection,
        emptyPetBehaviour,
        VSpacer(Dimension.SIZE_8)
    )
    
    lazy var preferencesContainer = stack(
        hstack(TitleH3(label: "Preferences"),
               UIView()),
        VSpacer(Dimension.SIZE_16),
        dogSizeStack,
        VSpacer(Dimension.SIZE_16),
        breedsContainer,
        VSpacer(Dimension.SIZE_16),
        petBehaviourContainer
    ).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }.withMargins(.init(vertical: 20, horizontal: 20))
    
    
    let reviewsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(ReviewsItemTableViewCell.self, forCellReuseIdentifier: ReviewsItemTableViewCell.Identifier)
    }
    lazy var emptyReviewsLabel = Caption(label: .MinderFullProfile.noReviews).apply { it in
        it.isHidden = true
    }
    
    lazy var reviewsContainer = stack(
        VSpacer(Dimension.SIZE_22),
        hstack(TitleH3(label: "Reviews"),UIView()),
        VSpacer(Dimension.SIZE_22),
        emptyReviewsLabel,
        reviewsTableView,
        VSpacer(Dimension.SIZE_22)
    ).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    lazy var containerStack = stack(
        profileImageView,
        VSpacer(Dimension.SIZE_8),
        titleContainer,
        locationWithContacts,
        VSpacer(Dimension.SIZE_22),
        statContainer,
        VSpacer(Dimension.SIZE_22),
        pathDistanceContainer,
        VSpacer(Dimension.SIZE_22),
        shortBioContainer,
        VSpacer(Dimension.SIZE_22),
        selectedPetsView,
        VSpacer(Dimension.SIZE_22),
        availabilityContainer,
        VSpacer(Dimension.SIZE_22),
        preferencesContainer,
        VSpacer(Dimension.SIZE_22),
        reviewsContainer,
        alignment: .center
    ).padTop(topPadding)
    
    
    let sendMessageButton = PrimaryButtonOutline(label: "Send Message", borderColor: .black, titleColor: .black).apply { it in
        it.layer.borderWidth = 1
    }
    
    let createRequestButton = PrimaryButton(label: "+ Create Request")
    
    lazy var bottomActionButtons = stack(
        VSpacer(Dimension.SIZE_22),
        sendMessageButton,
        VSpacer(Dimension.SIZE_12),
        createRequestButton
    ).withMargins(.horizontal(20)).apply { it in
        it.backgroundColor = .background
    }
    
    override func setupViews() {
        backgroundColor  = .background
        addSubViews(scrollView,bottomActionButtons)
        scrollView.addSubViews(containerStack,topStack)
    }
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerStack)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(bottomActionButtons.snp.topMargin)
        }
        
        bottomActionButtons.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.bottomMargin.equalTo(-15)
        }
        
        statContainer.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
        
        availabilityContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        availabilityDaysCollection.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        preferencesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        petBehaviourCollection.snp.makeConstraints { make in
            make.height.equalTo(150)
            
        }
        shortBioContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        selectedPetsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        reviewsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        reviewsTableView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
        
    }
    
    override func layoutSubviews() {
        availabilityDaysLayout.itemSize = .init(width: 65 , height: Int(Float(availabilityDaysCollection.frame.height)))
    }
    
    class FlowLabelItemCell : BaseUICollectionViewCell{
        
        let itemLabel = Caption(label: "Bulldog",font:.poppinsMedium(fontSize: 12)).apply{ it in
            it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        lazy var itemContainer = hstack(
            itemLabel
        ).withMargins(.init(vertical: 8, horizontal: 5))
            .apply { it in
                it.backgroundColor = UIColor(hexString: "#F4F4F4")
                it.layer.cornerRadius = 4
            }
        
        override func setupViews() {
            addSubViews(itemContainer)
        }
        
        override func setupConstraints() {
            itemContainer.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
            
        }
    }
}


