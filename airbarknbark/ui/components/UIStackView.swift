//
//  Stack.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/09/2022.
//

import Foundation
import UIKit

fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.axis = axis
    stackView.spacing = spacing
    stackView.alignment = alignment
    stackView.distribution = distribution
    return stackView
}

@discardableResult
func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
}

@discardableResult
func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
}
