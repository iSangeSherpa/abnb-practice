//
//  MinderDetailsView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/11/2022.
//

import Foundation
import UIKit

class FindingForDetailsView : BaseUIView{
    
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
    lazy var phoneContainer = hstack(UIImageView(icon: "ic_dialer_outline", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
                                     phoneLabel)
    lazy var locationWithContacts = hstack(
//        UIImageView(icon: "ic_location", tint: .onBackground.withAlphaComponent(0.8)).withWidth(12),
//        addressLabel,
//        HDivider(verticalMargin: 8),
        phoneContainer,
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    lazy var onGoingSessionButton = PrimaryButtonOutline(label: " Ongoing Sessions", font: .poppinsMedium(fontSize: 12), cornerRadius: 4, height: 28).apply{ (it:UIButton) in
        it.setImage(UIImage(systemName: "circle.fill")?.scaledDown(into: .init(width: 10, height: 10)).withTintColor(UIColor(hexString: "#3C9672")), for: .normal)
        it.layer.cornerRadius = 8
        it.setTitleColor(UIColor.onBackground, for: .normal)
        it.setTitleColor(UIColor.onBackground, for: .highlighted)
        it.layer.borderWidth = 1
        it.layer.borderColor = UIColor(hexString: "#3C9672").cgColor
    }
    
   
    
    let bookedDateLabel = TitleH3(label: "20th Jul, 2022")
    lazy var bookedAddress = TitleH3(label: "$240").apply { it in
        it.numberOfLines = 0
        it.textAlignment = .right
    }
    
    lazy var bookingDetailsTop = stack(
        hstack(
            Caption(label: "Booked for",font: .poppinsMedium(fontSize: 12), alpha: 0.8),
            HSpacer(Dimension.SIZE_8),
            UIView(),
            Caption(label: "Address",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
        ),
        VSpacer(Dimension.SIZE_8),
        hstack(
            bookedDateLabel,
            HSpacer(Dimension.SIZE_8),
            UIView(),
            bookedAddress,
            alignment: .top
        ).apply({ it in
            bookedAddress.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.5)
            }
        })
    )
    
    let timeLabel = TitleH3(label: "10:00 am - 04:00 pm")
    let totalPetLabel = TitleH3(label: "2")

    lazy var bookingDetailsBottom = stack(
        hstack(
            Caption(label: "Time",font: .poppinsMedium(fontSize: 12), alpha: 0.8),
            HSpacer(Dimension.SIZE_8),
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
    
    lazy var bookingDetailsContainer = stack(VSpacer(Dimension.SIZE_8),bookingDetailsTop,bookingDetailsBottom,VSpacer(Dimension.SIZE_8), spacing: Dimension.SIZE_22.cgFloat).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    let clockInTimeLabel = TitleH3(label: "10:00 am")
    let clockOutTimeLabel = TitleH3(label: "04:00 pm")
    
    lazy var mindingDetailsTop = stack(
        hstack(
            Caption(label: "Clock In",font: .poppinsMedium(fontSize: 12), alpha: 0.8),
            UIView(),
            Caption(label: "Clock Out",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
        ),
        VSpacer(Dimension.SIZE_8),
        hstack(
            clockInTimeLabel,
            UIView(),
            clockOutTimeLabel
        )
    )
    
    
    let timeRemainingTitleLabel = Caption(label: "Time remaining",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
    let timeRemainingLabel = TitleH3(label: "17 minutes")
    let totalSessionPaymentLabel = TitleH3(label: "$260")
    
    lazy var mindingDetailsBottom = stack(
        hstack(
            timeRemainingTitleLabel,
            UIView(),
            Caption(label: "Total pay",font: .poppinsMedium(fontSize: 12), alpha: 0.8)
        ),
        VSpacer(Dimension.SIZE_8),
        hstack(
            timeRemainingLabel,
            UIView(),
            totalSessionPaymentLabel
        ),
        VSpacer(Dimension.SIZE_16)
    )
    
    lazy var mindingDetailsContainer = stack(
        VSpacer(Dimension.SIZE_12),
        TitleH3(label: "Minding Session"),
        VSpacer(Dimension.SIZE_2),
        mindingDetailsTop,
        VSpacer(Dimension.SIZE_8),
        mindingDetailsBottom,
        spacing: Dimension.SIZE_8.cgFloat
    ).withMargins(.horizontal(20)).apply { it in
        it.layer.borderColor = UIColor.onBackground.withAlphaComponent(0.08).cgColor
        it.layer.borderWidth = 1
        it.layer.cornerRadius = 5
        it.backgroundColor = .surface
    }
    
    
    
    
    
    let fullProfile = hstack(
        Caption(label: "See full profile",font: .poppinsMedium(fontSize: 14), alpha: 0.8),
        HSpacer(Dimension.SIZE_8),
        UIImageView(icon: "ic_arrow_right").withSize(12)
    ).apply { it in
        it.enableRipple().rippleView.layer.cornerRadius = 8
        
    }.padTop(Dimension.SIZE_16.cgFloat).padBottom(Dimension.SIZE_16.cgFloat).padLeft(Dimension.SIZE_16.cgFloat).padRight(Dimension.SIZE_16.cgFloat)
    
    let reviewsTableView = UITableView().apply { it in
        it.showsVerticalScrollIndicator = false
        it.separatorStyle  = .none
        it.register(ReviewsItemTableViewCell.self, forCellReuseIdentifier: ReviewsItemTableViewCell.Identifier)
    }
    
    let rateMe = UIButton().apply { it in
        
        it.titleLabel?.font = .poppinsMedium(fontSize: 14)
        
        let fullText = " Rate Me? "
        let attributedRange = NSString(string: fullText).range(of: " Rate Me? ", options: String.CompareOptions.caseInsensitive)
       
        let attributedText = NSMutableAttributedString.init(string:fullText)
        
        attributedText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue as Any,
                                      NSAttributedString.Key.foregroundColor: UIColor.primary],range: attributedRange)
        
        it.setAttributedTitle(attributedText, for: .normal)
        it.setAttributedTitle(attributedText,for: .selected)

        it.enableRipple().rippleView.layer.cornerRadius = Dimension.SIZE_4.cgFloat
    }
    
    lazy var emptyReviewsLabel = Caption(label: .MinderFullProfile.noReviews).apply { it in
        it.isHidden = true
    }
    
    lazy var reviewsContainer = stack(
        VSpacer(Dimension.SIZE_22),
        hstack(TitleH3(label: "Reviews"), UIView(), rateMe),
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
        imageWithProgressBar,
        VSpacer(Dimension.SIZE_8),
        titleContainer,
        statContainer,
        locationWithContacts,
        VSpacer(Dimension.SIZE_8),
        onGoingSessionButton,
        VSpacer(Dimension.SIZE_22),
        bookingDetailsContainer,
        VSpacer(Dimension.SIZE_22),
        mindingDetailsContainer,
        VSpacer(Dimension.SIZE_22),
        fullProfile,
        VSpacer(Dimension.SIZE_22),
        reviewsContainer,
        alignment: .center
    ).padTop(topPadding)
    
    let dialerButton = ButtonBox(icon: UIImage(named: "ic_dialer")?.withTintColor(.black),size: 50)
    let sendMessageButton = PrimaryButton(label: "Send Message")
    
    lazy var bottomActionButtons = hstack(
        dialerButton,
        sendMessageButton,
        spacing: Dimension.SIZE_16.cgFloat
    ).withMargins(.horizontal(20))
    
    override func setupViews() {
        backgroundColor  = .background
        addSubViews(scrollView,bottomActionButtons)
        scrollView.addSubViews(containerStack,topStack)
    }
    
    override func setupConstraints() {
        onGoingSessionButton.snp.makeConstraints { make in
            make.width.equalTo(145)
        }
        
        
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
        
        mindingDetailsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        bookingDetailsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.left.equalTo(self.snp.left).offset(Dimension.SCREEN_PADDING)
            make.right.equalTo(self.snp.right).offset(-Dimension.SCREEN_PADDING)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
        }
        
        reviewsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        reviewsTableView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
    }
}


