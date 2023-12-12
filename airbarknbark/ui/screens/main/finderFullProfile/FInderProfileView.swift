//
//  FInderProfileView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 28/12/2022.
//

import Foundation
import UIKit

class FinderProfileView : BaseUIView{
    
    let topPadding = Dimension.SIZE_46.cgFloat
    
    let backButton = BackButton()
    let rightButton = UIButton().apply { it in
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.65)
        it.contentMode = .center
        it.setBackgroundImage(UIImage(named: "ic_ellipsis"), for: .normal)
    }
    
    lazy var topStack = hstack(backButton,UIView(),rightButton).padTop(topPadding).padLeft(-Dimension.SIZE_8.cgFloat)
    
    let idVerifiedButton = IdVerifiedButton()
    
    let scrollView  = UIScrollView().apply { it in
        it.translatesAutoresizingMaskIntoConstraints = true
    }
    
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
    
    lazy var statContainer = hstack(UIView(),ratingView,UIView(),distribution: .equalCentering)
    
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
    
    let shortBioLabel =  Caption(label: "",font: .poppinsRegular(fontSize: 14), alpha: 0.8).apply { it in
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
    
    
    let petsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(PetsWithAboutTableViewCell.self, forCellReuseIdentifier: PetsWithAboutTableViewCell.Identifier)
    }
    
    lazy var emptyPetsLabel = Caption(label: .MinderFullProfile.noPets).apply { it in
        it.isHidden = true
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
        reviewsContainer,
        alignment: .center
    ).padTop(topPadding)
    
    
    let sendMessageButton = PrimaryButtonOutline(label: "Send Message", borderColor: .black, titleColor: .black).apply { it in
        it.layer.borderWidth = 1
    }
    
    override func setupViews() {
        backgroundColor  = .background
        addSubViews(scrollView)
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
            make.bottom.equalTo(self.snp.bottomMargin)
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
}


