//
//  ViewWithPickerView+Bind.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/09/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct ViewWithPickerView<Parent : UIView, Picker:UIView>{
    var field: Parent
    var pickerView: Picker
}

extension ViewWithPickerView where Parent : UITextField, Picker : UIPickerView{
    
    func bind<AllItems:ObservableType, Selected:RelayType, Sequence: Swift.Sequence>
    (
        allItems:AllItems,
        selected:Selected,
        onItemSelected : ((Sequence.Element?)->Void)? = nil,
        by: @escaping (Sequence.Element?)->String?
    )
    -> Disposable where
    AllItems.Element == Sequence,
    Selected.RelayElement == Sequence.Element?
    {
       
        let disposale = CompositeDisposable()
        
        _ = disposale.insert(
            allItems.bind(to: pickerView.rx.itemTitles){ _, item in
                by(item)
            })
        
        _ =  disposale.insert(
            pickerView.rx.itemSelected
                .asObservable()
                .withLatestFrom(allItems){ (index, items) -> Sequence.Element? in
                    items[index.row]
                }.bind(onNext: {
                    selected.accept($0)
                    onItemSelected?($0)
                })
        )
        
        _ = disposale.insert(
            selected.map { (item : Sequence.Element?) -> String? in
                by(item)
            }.bind(to: field.rx.text)
        )
        
        let sleeve = ClosureSleeve(attachTo: self.field) {
            let d = allItems.bind(onNext: { items in
                selected.accept(items[pickerView.selectedRow(inComponent: 0)])
                onItemSelected?(items[pickerView.selectedRow(inComponent: 0)])
            })
           _ = disposale.insert(d)
        }
        
        self.field.keyboardToolbar.doneBarButton.setTarget(sleeve, action: #selector(ClosureSleeve.invoke))
        
        
        return disposale
    }
}


extension ViewWithPickerView where Parent : UITextField, Picker : UIDatePicker{
    
    func bind<Selected:RelayType>
    (
        selected:Selected,
        onItemSelected : ((Date?)->Void)? = nil,
        by: @escaping (Date?)->String?
    )
    -> Disposable where
    Selected.RelayElement == Date?
    {
        let sleeve = ClosureSleeve(attachTo: self.field) {
            selected.accept(self.pickerView.date)
        }
        self.field.keyboardToolbar.doneBarButton.setTarget(sleeve, action: #selector(ClosureSleeve.invoke))
        
        let disposale = CompositeDisposable()
        
        _ = disposale.insert(
            selected.map { (item : Date?) -> String? in
                by(item)
            }.bind(to: field.rx.text)
        )
        
        _ = disposale.insert(pickerView.rx.value.asObservable()
            .skip(1)
             .bind { date in
                 selected.accept(date)
                 onItemSelected?(date)
             })
        
        return disposale
    }
}
