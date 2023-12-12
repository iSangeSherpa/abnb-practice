//
//  BothHomeTabView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 03/01/2023.
//

import Foundation
import UIKit

class BothHomeTabView : BaseUIView{
    
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
    
    lazy var scrollView  = UIScrollView().apply { it in
        it.refreshControl = refreshControl
    }
    
    
    let userHeader = TitleH1(label: "Hello Matt!")
    let userGreeting = TextBody(label: "Good Morning!")
    
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
    
    lazy var greetingContainer = hstack(
        stack(
            userHeader,
            userGreeting.withHeight(20),
            alignment: .leading
        ),
        UIView(),
        availabilitySwitchContainer
    )
    
    let activeMindingsForLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var activeMindingsForCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: activeMindingsForLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(ActiveMindingItemCell.self)
    }
    let activeMindingsByLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var activeMindingsByCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: activeMindingsByLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.register(ActiveMindingItemCell.self)
    }
    
    lazy var emptyActiveMindingListLabel = Caption(label: "No active sessions").apply { it in
        it.isHidden = true
    }
    lazy var emptyRequestListLabel = Caption(label: "No requests").apply { it in
        it.isHidden = true
    }
    
    lazy var emptyBookingListLabel = Caption(label: "No bookings").apply { it in
        it.isHidden = true
    }
    
    let activeMindingToggleView = ForByToggleView(forTitle: .HomeTab.mindingFor, byTitle: .HomeTab.mindingBy).apply { it in
        it.forBy = .FOR
    }
    
    lazy var activeMindingHeadingView = hstack(
        activeMindingToggleView,
        UIView(),
        DotView(8),
        Caption(label: "Ongoing Session"),
        spacing:Dimension.SIZE_8.cgFloat
    )
        
    lazy var activeMindingView = OutlineLabelOn { parent in
        let innerView = stack(
            emptyActiveMindingListLabel,
            activeMindingsForCollection,
            activeMindingsByCollection,
            spacing: Dimension.SIZE_12.cgFloat
        )
        
        activeMindingsForCollection.backgroundColor = .background
        activeMindingsByCollection.backgroundColor = .background
        
        parent.addSubViews(innerView)
        
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        activeMindingsForCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
        activeMindingsByCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
    }
    
    let viewAllRequestsButton = TextButton(label: "See all >", font:UIFont.caption)
    
    
    let requestsForLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var requestsForCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: requestsForLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MindingRequestItemCell.self)
    }
    let requestsByLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .horizontal
    }
    
    lazy var requestsByCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: requestsByLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MindingRequestItemCell.self)
    }
    
    lazy var requestsToggleView = ForByToggleView(forTitle: .HomeTab.sentRequest, byTitle: .HomeTab.receivedRequest).apply { it in
        it.forBy = .FOR
    }
    
    lazy var requestsHeadingView =  hstack(
        requestsToggleView,
        UIView(),
        stack(UIView(),viewAllRequestsButton,UIView()),
        spacing:Dimension.SIZE_8.cgFloat
    )
    
    lazy var requestsView = OutlineLabelOn { parent in
        let innerView = stack(
            emptyRequestListLabel,
            requestsForCollection,
            requestsByCollection,
            spacing: Dimension.SIZE_8.cgFloat
        )
        
        requestsForCollection.backgroundColor = .background
        requestsByCollection.backgroundColor = .background
        
        parent.addSubViews(innerView)
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        requestsForCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
        requestsByCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
    }
    
    
    let viewAllBookingsButton = TextButton(label: "See all >", font:UIFont.caption)
    
    let bookingsForLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var bookingsForCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: bookingsForLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(BookingItemCell.self)
    }
    
    let bookingsByLayout = UICollectionViewFlowLayout().apply{ it in
        it.scrollDirection = .vertical
    }
    
    lazy var bookingsByCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: bookingsByLayout
    ).apply { collectionView in
        collectionView.showsVerticalScrollIndicator  = false
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(BookingItemCell.self)
    }
    
    let bookingsToggleView = ForByToggleView(forTitle: .HomeTab.sentBooking, byTitle: .HomeTab.receivedBooking).apply { it in
        it.forBy = .FOR
    }
    
    lazy var bookingsHeadingView = hstack(
        bookingsToggleView,
        UIView(),
        stack(UIView(),viewAllBookingsButton,UIView()),
        spacing:Dimension.SIZE_8.cgFloat
    )
    
    lazy var bookingsView = OutlineLabelOn { parent in
        let innerView = stack(
            emptyBookingListLabel,
            bookingsForCollection,
            bookingsByCollection,
            spacing: Dimension.SIZE_12.cgFloat
        )
        
        bookingsForCollection.backgroundColor = .background
        bookingsByCollection.backgroundColor = .background
        
        parent.addSubViews(innerView)
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.SIZE_16)
        }
        
        bookingsForCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
            make.height.equalTo(180)
        }
        bookingsByCollection.snp.makeConstraints { make in
            //MARK: Collection View Height
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
        activeMindingHeadingView,
        activeMindingView,
        VSpacer(Dimension.SIZE_8),
        requestsHeadingView,
        requestsView,
        VSpacer(Dimension.SIZE_8),
        bookingsHeadingView,
        bookingsView,
        VSpacer(Dimension.SIZE_36),
        spacing: Dimension.SIZE_4.cgFloat,
        alignment: .fill
    )
    
    override func setupViews() {
        addSubViews(scrollView,topStack)
        scrollView.addSubview(containerStack)
    }
    
    override func setupConstraints() {
        
        emptyActiveMindingListLabel.snp.makeConstraints { make in
            make.top.equalTo(Dimension.SIZE_16)
        }
        emptyRequestListLabel.snp.makeConstraints { make in
            make.top.equalTo(Dimension.SIZE_16)
        }
        emptyBookingListLabel.snp.makeConstraints { make in
            make.top.equalTo(Dimension.SIZE_16)
        }
        
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
    
    func updateNotificationIcon(hasUnreadNotification : Bool){
        notificationIcon.image = hasUnreadNotification ?  UIImage(named: "ic_notification_unread") :UIImage(named: "ic_notification")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activeMindingsForLayout.itemSize = .init(width: Int(Float(activeMindingsForCollection.frame.width)), height: 95)
        activeMindingsByLayout.itemSize = .init(width: Int(Float(activeMindingsByCollection.frame.width)), height: 95)
        requestsForLayout.itemSize = .init(width: 150, height: 180)
        requestsByLayout.itemSize = .init(width: 150, height: 180)
        bookingsForLayout.itemSize = .init(width: Int(Float(bookingsForCollection.frame.width)), height: 90)
        bookingsByLayout.itemSize = .init(width: Int(Float(bookingsByCollection.frame.width)), height: 90)
        
    }
    
}



class ForByToggleView : BaseUIView{

    enum ForBy{
        case FOR
        case BY
    }
    
    var valueChangeListener : ((ForBy)->())? = nil
    
    var forBy : ForBy = .FOR{
        didSet{
            updateViewForSelectedItem()
            self.valueChangeListener?(forBy)
        }
    }
    
    let forTitle = TitleH3(label: "").apply { it in
        it.font = .poppinsSemibold(fontSize: 12)
    }
    
    lazy var forTitleWrapper =  hstack(
        forTitle
    ).withMargins(.init(vertical: Dimension.SIZE_4.cgFloat, horizontal: Dimension.SIZE_4.cgFloat)).apply { it in
        it.enableRipple().apply { it in
            it.rippleView.layer.cornerRadius = 4
            it.rippleView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(-3)
            }
        }
    }
    
    let byTitle = TitleH3(label: "").apply { it in
        it.font = .poppinsSemibold(fontSize: 12)
    }
    
    lazy var byTitleWrapper =  hstack(
        byTitle
    ).withMargins(.init(vertical: Dimension.SIZE_4.cgFloat, horizontal: Dimension.SIZE_4.cgFloat)).apply { it in
        it.enableRipple().apply { it in
            it.rippleView.layer.cornerRadius = 4
            it.rippleView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(-3)
            }
        }
    }
    
    lazy var highlighter = UIView().apply { it in
        it.backgroundColor = .primary
    }
    
    
    lazy var forByToggleView = stack(
        hstack(
            forTitleWrapper,
            HSpacer(Dimension.SIZE_4),
            byTitleWrapper,
            UIView()
        ),
        VSpacer(12),
        spacing:Dimension.SIZE_8.cgFloat
       
    )
    
    var forTitleText:String!
    var byTitleText:String!
    
    required init(forTitle:String , byTitle:String){
        super.init(frame: .zero)
        
        self.forTitleText = forTitle
        self.byTitleText = byTitle
        
        self.forTitle.text = forTitle
        self.byTitle.text = byTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func setupViews() {
        subviews.forEach { $0.removeFromSuperview() }
        
        self.addSubViews(forByToggleView,highlighter)
        
        forTitleWrapper.addOnClickListner {[unowned self] in
            self.forBy = .FOR
        }
        
        byTitleWrapper.addOnClickListner {[unowned self] in
            self.forBy = .BY
        }
        
    }
    
    override func setupConstraints() {
        self.forByToggleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateViewForSelectedItem(){
        let selectedView = forBy == .BY ? byTitle : forTitle;
        
        highlighter.snp.remakeConstraints { make in
            make.left.right.equalTo(selectedView)
            make.top.equalTo(selectedView.snp.bottom).offset(5)
            make.height.equalTo(4)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0){ [self] in
            self.forTitle.alpha = forBy == .FOR ?  1 : 0.5
            self.byTitle.alpha = forBy == .BY ?  1 : 0.5
        }
    }
    
    func addOnValueChangeListener(valueChangeListener : ((ForBy)->())? = nil){
        self.valueChangeListener = valueChangeListener
    }
    
    func updateForTitleAppendingText(_ appendingText : String){
        forTitle.text = "\(forTitleText ?? "")\(appendingText)"
        self.layoutSubviews()
    }
    
    func updateByTitleAppendingText(_ appendingText : String){
        byTitle.text = "\(byTitleText ?? "")\(appendingText)"
        self.layoutSubviews()
    }
}
