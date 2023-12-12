//
//  RequestDetailsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 04/11/2022.
//

import Foundation
import UIKit

class FinderRequestDetailsView : BaseUIView{
    
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
    
    lazy var imageView = UIImageView(image: UIImage(named: "user_placeholder")).withSize(80)
    
    lazy var imageWithProgressBar  = ProgressBackground().apply{ it in
        it.arcFillColor = .secondary
        it.addSubview(imageView)
        
        imageView.backgroundColor  = .background
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.background.cgColor
        imageView.layer.cornerRadius = (80)/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    let nameLabel = TitleH3(label: "John Doe")
    let idVerifiedButton = IdVerifiedButton()
    
    lazy var titleContainer = stack(
        nameLabel,
        idVerifiedButton,
        spacing: Dimension.SIZE_2.cgFloat,
        alignment: .center
    )
    
    let ratingLabel =  Caption(label: "4.7",font: .poppinsSemibold(fontSize: 12), alpha: 0.7).apply { it in
        it.numberOfLines = 1
    }
    let expLabel =  Caption(label: "1 Year Exp",font: .poppinsSemibold(fontSize: 12), alpha: 0.7)
    
    lazy var statContainer = hstack(
        UIImageView(icon: "ic_paw").withWidth(16),
        ratingLabel,
        HDivider(verticalMargin: 8),
        UIImageView(icon: "ic_briefcase",tint: UIColor(hexString: "#888888")).withWidth(14),
        expLabel,
        UIView(),
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    let addressLabel =  Caption(label: "California, US",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
    let phoneLabel = Caption(label: "+1 892374122",font: .poppinsMedium(fontSize: 12),alpha: 0.8)
    lazy var phoneContainer = hstack( UIImageView(icon: "ic_dialer_outline", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
                                      phoneLabel)
    lazy var locationWithContacts = hstack(
//        UIImageView(icon: "ic_location", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
//        addressLabel,
//        HDivider(verticalMargin: 8),
        phoneContainer,
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    let bookedDateLabel = TitleH3(label: "20th Jul, 2022")
    let totalPayLabel = TitleH3(label: "$240")
    
    let editBookingButton = UIButton().apply { it in
        it.withSize(12)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.95)
        it.contentMode = .scaleAspectFit
        it.setBackgroundImage(UIImage(named: "ic_edit_profile")?.withTintColor(.onBackground.withAlphaComponent(0.8)), for: .normal)
    }
    lazy var detailsTop = stack(
        hstack(
            Caption(label: "Booked for",font: .poppinsMedium(fontSize: 12), alpha: 0.8),
            HSpacer(Dimension.SIZE_8),
            editBookingButton,
            UIView(),
            Caption(label: "Total pay",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
        ),
        VSpacer(Dimension.SIZE_8),
        hstack(
            bookedDateLabel,
            UIView(),
            totalPayLabel
        )
    )
    
    let timeLabel = TitleH3(label: "10:00 am - 04:00 pm")
    let totalPetLabel = TitleH3(label: "2")
    
    let editTimeImageView = UIButton().apply { it in
        it.withSize(12)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.95)
        it.contentMode = .scaleAspectFit
        it.setBackgroundImage(UIImage(named: "ic_edit_profile")?.withTintColor(.onBackground.withAlphaComponent(0.8)), for: .normal)
    }
    lazy var detailsBottom = stack(
        hstack(
            Caption(label: "Time",font: .poppinsMedium(fontSize: 12), alpha: 0.8),
            HSpacer(Dimension.SIZE_8),
            editTimeImageView,
            UIView(),
            Caption(label: "Total pet",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
        ),
        VSpacer(Dimension.SIZE_8),
        hstack(
            timeLabel,
            UIView(),
            totalPetLabel
        )
    )
    
    let requestStatusButton = PrimaryButtonOutline(
        label: "Request Pending",
        borderColor: UIColor(hexString: "#D0A114"),
        font: .poppinsMedium(fontSize: 12),
        titleColor: UIColor(hexString: "#D0A114"),
        cornerRadius: 4,
        height: 40
    )
    lazy var detailsContainer = stack(VSpacer(Dimension.SIZE_8),detailsTop,detailsBottom,requestStatusButton,VSpacer(Dimension.SIZE_8), spacing: Dimension.SIZE_22.cgFloat).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    let selectedPetsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var selectedPetsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: selectedPetsLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(SelectedPetsItemCell.self)
    }
    let editSelectedPet = UIButton().apply { it in
        it.withSize(16)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.95)
        it.contentMode = .scaleAspectFit
        it.setBackgroundImage(UIImage(named: "ic_edit_profile")?.withTintColor(.onBackground.withAlphaComponent(0.8)), for: .normal)
    }
    
    lazy var selectedPetsView = stack(
        VSpacer(Dimension.SIZE_22),
        hstack(TitleH3(label: "Selected Pet"),UIView(),editSelectedPet),
        VSpacer(Dimension.SIZE_22),
        selectedPetsCollection,
        VSpacer(Dimension.SIZE_22)
    ).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
        
        selectedPetsCollection.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }
    
    
    let reviewsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(ReviewsItemTableViewCell.self, forCellReuseIdentifier: ReviewsItemTableViewCell.Identifier)
    }
    
    let seeAllReviews = TextButton(label: "See all >", font:UIFont.caption)
    lazy var emptyReviewsLabel = Caption(label: .MinderFullProfile.noReviews).apply { it in
        it.isHidden = true
    }
    lazy var reviewsView = stack(
        VSpacer(Dimension.SIZE_22),
        hstack(TitleH3(label: "Reviews"),UIView(),seeAllReviews),
        VSpacer(Dimension.SIZE_22),
        emptyReviewsLabel,
        reviewsTableView,
        VSpacer(Dimension.SIZE_22)
    ).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
        
        reviewsTableView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }

    
    lazy var containerStack = stack(
        imageWithProgressBar,
        VSpacer(Dimension.SIZE_8),
        titleContainer,
        statContainer,
        locationWithContacts,
        VSpacer(Dimension.SIZE_22),
        detailsContainer,
        VSpacer(Dimension.SIZE_22),
        selectedPetsView,
        VSpacer(Dimension.SIZE_22),
        reviewsView,
        alignment: .center
    ).padTop(topPadding)
    

    let cancelBookingButton = PrimaryButton(label: "Cancel Booking").apply {
        $0.backgroundColor = UIColor(hexString: "#8B8B8B")
        $0.configuration?.baseBackgroundColor = UIColor(hexString: "#8B8B8B")
    }
    let cancelNote =  Caption(label: "*all changes can only be done 48 hours before",font: .poppinsMedium(fontSize: 11))
    
    lazy var bottomActionButtons = stack(
        VSpacer(Dimension.SIZE_22),
        cancelBookingButton,
        VSpacer(Dimension.SIZE_4),
        cancelNote
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
            make.height.equalTo(150)
        }
        detailsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
        
        selectedPetsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        reviewsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    
    }
    
    override func layoutSubviews() {
        selectedPetsLayout.itemSize = .init(width: Int(Float(selectedPetsCollection.frame.width)), height: 95)
       }
}
