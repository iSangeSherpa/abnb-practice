//
//  ReportAccountDialog.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 18/11/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class ReportAccountDialog: BaseUIView{
    var reasonsTag : [Selectable<String>] = []
    
    let crossButton = UIButton().apply { it in
        it.withSize(24)
        it.setImage(UIImage(named: "ic_cross"), for: .normal)
        it.enableRipple(rippleColor: .primary.withAlphaComponent(0.1), style: .unbounded, factor: 0.8)
    }
    
    let submitButton = PrimaryButton(label: "Submit").apply { it in
        it.withWidth(UIScreen.main.bounds.width)
    }
    
    lazy var titleHStack = hstack(
        TitleH3(label: "Why are you reporting this account?"),
        alignment: .center,
        distribution: .equalSpacing
    )
    
    lazy var reasonsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomViewFlowLayout()
    ).apply { collectionView in
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.register(MinderFullProfileView.FlowLabelItemCell.self)
    }
    
    let reasonTextView = UITextView().withHeight(100).apply { it in
        it.font = .poppinsRegular(fontSize: 14)
        it.textColor = .onBackground
        it.text = "Write your own...."
    }
    
    lazy var reasonTextViewWrapper = reasonTextView.wrapInUIView { container, child in
        container.backgroundColor = UIColor(hexString: "#F4F4F4")
        child.backgroundColor = UIColor(hexString: "#F4F4F4")
        let textView = (child as! UITextView)
        textView.textContainer.maximumNumberOfLines = 4
        
        child.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    lazy var containerStack = stack(
        hstack(UIView(),crossButton),
        titleHStack,
        VSpacer(Dimension.SIZE_4),
        reasonsCollection,
        VSpacer(Dimension.SIZE_8),
        reasonTextViewWrapper,
        VSpacer(Dimension.SIZE_8),
        submitButton,
        spacing: Dimension.SIZE_2.cgFloat
    )
    
    override func setupViews() {
        addSubview(containerStack)
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    override func setupConstraints() {
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets.allSides(Dimension.SIZE_22.cgFloat))
        }
        reasonsCollection.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        
    }
}
extension ReportAccountDialog : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reasonTextView.textColor == .onBackground {
            reasonTextView.text = ""
            reasonTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if reasonTextView.text == "" {
            reasonTextView.text = "Write your own...."
            reasonTextView.textColor = .onBackground
        }
    }
}

extension ReportAccountDialog: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemStringFrame = NSString(string:  reasonsTag[indexPath.row].item)
        let estimatedFrame = itemStringFrame.boundingRect(with: CGSize(width: 1000, height: 20),options: .usesLineFragmentOrigin,attributes: [NSAttributedString.Key.font: UIFont.poppinsMedium(fontSize: 16)], context: nil)
        return CGSize(width : estimatedFrame.width + 10, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ReportAccountDialog {
    static func showReportAccountDialog(vc: UIViewController) -> Maybe<[String]>{
        return [.create{ [vc] maybe in
            let viewController = DialogViewController<ReportAccountDialog,ViewModel>().setupBy { dialog in
                
                let reasonTags = BehaviorRelay<[Selectable<String>]>(value: [
                    Selectable(item: "Untimely", isSelected: false),
                    Selectable(item: "Fake profile.", isSelected: false),
                    Selectable(item: "Rude behaviour.", isSelected: false),
                    Selectable(item: "Overrated.",isSelected: false)
                ])
                
                dialog.binding.crossButton.addOnClickListner { 
                    maybe(.completed)
                }
                
                dialog.binding.submitButton.addOnClickListner {
                    
                    var selectedReason =  reasonTags.value.filter({ items in
                        items.isSelected
                    }).map({ item in
                        item.item
                    })
                    
                    if(selectedReason.isEmpty){
                        if(!dialog.binding.reasonTextView.text.isEmpty && dialog.binding.reasonTextView.text != "Write your own...."){
                            selectedReason.append(dialog.binding.reasonTextView.text)
                        }else{
                            return
                        }
                    }
                    maybe(.success(selectedReason))
                }
                
                
                dialog.binding.reasonsTag = reasonTags.value
                dialog.binding.reasonsCollection.rx.setDelegate(dialog.binding).disposed(by: dialog.disposeBag)
                dialog.binding.reasonTextView.delegate = dialog.binding
                
                reasonTags.bind(to: dialog.binding.reasonsCollection.rx.items(cellIdentifier: MinderFullProfileView.FlowLabelItemCell.Identifier)){ (row, item, cell)  in
                    let cell = cell as! MinderFullProfileView.FlowLabelItemCell
                    cell.itemLabel.text = item.item
                    cell.itemContainer.backgroundColor = item.isSelected ? UIColor(hexString: "#E0E0E0") : UIColor(hexString: "#F4F4F4")
                    
                    
                    cell.addOnClickListner {
                        reasonTags.accept(reasonTags.value.map { it in
                            it.item == item.item ? it.copy(isSelected: !item.isSelected) : it.copy(isSelected: false)
                        })
                    }
                    
                }.disposed(by: dialog.disposeBag)
                
                reasonTags.delay(.milliseconds(10), scheduler: MainScheduler.instance).bind { [unowned vc] items in
                    UIView.animate(withDuration: 0.4) { [unowned vc] in
                        dialog.binding.reasonsCollection.snp.updateConstraints{ make in
                            make.height.equalTo(max(dialog.binding.reasonsCollection.contentSize.height, 32))
                        }
                        dialog.binding.layoutIfNeeded()
                    }
                }.disposed(by: dialog.disposeBag)
            }
            vc.present(viewController, animated: true)
            return Disposables.create {
                viewController.dismiss(animated: true)
            }
        }][0]
    }
    
    
    
}
