//
//  CustomFlowLayout.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 14/11/2022.
//

import Foundation
import UIKit

class CustomViewFlowLayout: UICollectionViewFlowLayout {

let cellSpacing:CGFloat = 4

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            self.minimumLineSpacing = 4.0
            self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let attributes = super.layoutAttributesForElements(in: rect)

            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            attributes?.forEach { layoutAttribute in
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + cellSpacing
                maxY = max(layoutAttribute.frame.maxY , maxY)
            }
            return attributes
    }
}
