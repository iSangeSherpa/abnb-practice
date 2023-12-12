//
//  HomeTabView.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 13/10/2022.
//

import Foundation
import UIKit

class FinderHomeTabView : BaseUIView{
    
    let topDogIcon = UIImageView( image: UIImage(named: "ic_airbark_logo")).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple(style:.unbounded)
        it.isUserInteractionEnabled  = true
    }
    
    let calendarIcon = UIImageView( image: UIImage(named: "ic_calendar")).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple(style:.unbounded)
        it.isUserInteractionEnabled  = true
        it.isHidden  = true
    }
    
    let notificationIcon = UIImageView( image: UIImage(named: "ic_notification")).apply { it in
        it.contentMode = .scaleAspectFit
        it.enableRipple(style:.unbounded)
        it.isUserInteractionEnabled  = true
    }
    
    let refreshControl = UIRefreshControl()
    
    let availabilityLabel = Caption(label: "Not Available").apply({ it in
        it.textColor = .white
        it.font = .poppinsRegular(fontSize: 12)
    })
    let availabilitySwitch = UISwitch().apply { it in
        it.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        it.thumbTintColor = UIColor(hexString: "#B2B3B3")
        it.onTintColor = .white
        it.layer.cornerRadius = it.frame.height / 1
        it.backgroundColor = .white
        it.clipsToBounds = true
    }
    lazy var availabilitySwitchContainer = hstack(
        availabilitySwitch,
        availabilityLabel,
        UIView(),
        alignment: .center
    ).withHeight(40).withWidth(150)
        .withMargins(.horizontal(Dimension.SIZE_4.cgFloat)).apply { it in
            it.backgroundColor = UIColor(hexString: "#B2B3B3")
            it.layer.cornerRadius = 5
        }
    
    lazy var scrollView  = UIScrollView().apply { it in
        it.refreshControl = refreshControl
    }
    
    let userHeader = TitleH1(label: "Hello Matt!")
    let userGreeting = TextBody(label: "Good Morning!")
    
    lazy var searchMinderButton = PrimaryButton(label: "Search Locations").apply { (button: UIButton) in
        button.setImage( UIImage(named: "ic_search"), for: .normal)
        button.configuration?.imagePadding = Dimension.SIZE_8.cgFloat
        button.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing:20)
    }
    
    lazy var greetingContainer = stack(
        hstack(
            stack(
                userHeader,
                userGreeting.withHeight(20),
                alignment: .leading
            ),
            UIView(),
            searchMinderButton
        ),
        VSpacer(10),
        hstack(UIView(),availabilitySwitchContainer))
    
    lazy var emptyActiveMindingListLabel = Caption(label: "No active sessions").apply { it in
        it.isHidden = true
    }
    lazy var emptyRequestListLabel = Caption(label: "No requests").apply { it in
        it.isHidden = true
    }
    lazy var emptyBookingListLabel = Caption(label: "No bookings").apply { it in
        it.isHidden = true
    }
    
    let activeMindingsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var activeMindingsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: activeMindingsLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(ActiveMindingItemCell.self)
    }
    
    lazy var activeMindingView = OutlineLabelOn { parent in
        let innerView = stack(
            hstack(
                TitleH3(label: "Minding by"),
                UIView(),
                DotView(8),
                Caption(label: "Ongoing Session"),
                spacing:Dimension.SIZE_8.cgFloat
            ),
            emptyActiveMindingListLabel,
            activeMindingsCollection,
            spacing: Dimension.SIZE_12.cgFloat
        )
        
        activeMindingsCollection.backgroundColor = .background
        parent.addSubViews(innerView)
        
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        activeMindingsCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
    }
    
    let viewAllRequestsButton = TextButton(label: "See all >", font:UIFont.caption)
    
    
    let requestsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var requestsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: requestsLayout
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(MindingRequestItemCell.self)
    }
    
    lazy var requestsView = OutlineLabelOn { parent in
        let innerView = stack(
            hstack(
                TitleH3(label: "Requests"),
                UIView(),
                viewAllRequestsButton,
                spacing:Dimension.SIZE_8.cgFloat
            ),
            emptyRequestListLabel,
            requestsCollection,
            spacing: Dimension.SIZE_8.cgFloat
        )
        
        requestsCollection.backgroundColor = .background
        parent.addSubViews(innerView)
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        requestsCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
    }
    
    
    let viewAllBookingsButton = TextButton(label: "See all >", font:UIFont.caption)
    
    
    let bookingsLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var bookingsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: bookingsLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(BookingItemCell.self)
    }
    
    lazy var bookingsView = OutlineLabelOn { parent in
        let innerView = stack(
            hstack(
                TitleH3(label: "Bookings"),
                UIView(),
                viewAllBookingsButton,
                spacing:Dimension.SIZE_8.cgFloat
            ),
            emptyBookingListLabel,
            bookingsCollection,
            spacing: Dimension.SIZE_12.cgFloat
        )
        bookingsCollection.backgroundColor = .background
        parent.addSubViews(innerView)
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        bookingsCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
    }
    
    let viewAllRecentSession = TextButton(label: "See all >", font:UIFont.caption)
    
    lazy var emptyRecentSessionLabel = Caption(label: "No recent session").apply { it in
        it.isHidden = true
    }
    let recentSessionLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var recentSessionCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: recentSessionLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(PastWorksItemCell.self)
    }
    
    lazy var recentSessionView = OutlineLabelOn { parent in
        let innerView = stack(
            hstack(
                TitleH3(label: "Recent Sessions"),
                UIView(),
                viewAllRecentSession,
                spacing:Dimension.SIZE_8.cgFloat
            ),
            emptyRecentSessionLabel,
            recentSessionCollection,
            spacing: Dimension.SIZE_12.cgFloat
        )
        recentSessionCollection.backgroundColor = .background
        
        parent.addSubViews(innerView)
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        recentSessionCollection.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }
    
    lazy var topActionStack = hstack(
        topDogIcon.withSize(46),
        UIView(),
        calendarIcon.withSize(22),
        notificationIcon.withSize(22),
        spacing: Dimension.SIZE_12.cgFloat,
        alignment: .center
    )
    
    lazy var topStack = stack(
        topActionStack,
        greetingContainer,
        VSpacer(Dimension.SIZE_8),
        spacing: Dimension.SIZE_8.cgFloat
    )
    
    lazy var containerStack = stack(
        VSpacer(Dimension.SIZE_8),
        activeMindingView,
        VSpacer(Dimension.SIZE_8),
        requestsView,
        VSpacer(Dimension.SIZE_8),
        bookingsView,
        VSpacer(Dimension.SIZE_8),
        recentSessionView,
        VSpacer(Dimension.SIZE_36),
        spacing: Dimension.SIZE_4.cgFloat,
        alignment: .fill
    )
    
    func updateNotificationIcon(hasUnreadNotification : Bool){
        notificationIcon.image = hasUnreadNotification ?  UIImage(named: "ic_notification_unread") :UIImage(named: "ic_notification")
    }
    
    override func setupViews() {
        addSubViews(scrollView,topStack)
        scrollView.addSubview(containerStack)
    }
    
    override func setupConstraints() {
        
        topStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.topMargin.equalToSuperview().inset(Dimension.SCREEN_PADDING)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topStack.snp.bottom)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(Dimension.SCREEN_PADDING)
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activeMindingsLayout.itemSize = .init(width: Int(Float(activeMindingsCollection.frame.width)), height: 95)
        bookingsLayout.itemSize = .init(width: Int(Float(bookingsCollection.frame.width)), height: 90)
        requestsLayout.itemSize = .init(width: 150, height: 180)
        recentSessionLayout.itemSize = .init(width: Int(Float(recentSessionCollection.frame.width)), height: 90)
        
    }
    
}
