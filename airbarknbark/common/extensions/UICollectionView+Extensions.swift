//
//  UICollectionView+Extensions.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 12/10/2022.
//

import Foundation
import UIKit

extension UICollectionView{
    
    func register<Cell:BaseUICollectionViewCell>(_ cellClass: Cell.Type){
        register(cellClass, forCellWithReuseIdentifier: Cell.Identifier)
    }
    
}
