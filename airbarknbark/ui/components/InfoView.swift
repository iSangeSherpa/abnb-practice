//
//  InfoView.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 19/01/2023.
//

import Foundation
import UIKit

func InfoView(_ infoText:String,_ showIcon:Bool = true) -> UIView{
    hstack(
        HSpacer(2),
        stack(
            VSpacer(Dimension.SIZE_2),
            UIImageView(image: UIImage(named: "ic_info")?.withTintColor(.onBackground.withAlphaComponent(0.6))).withSize(showIcon ? 12 : 0),
            UIView()
        ),
        UILabel().apply{ it in
            it.text = infoText
            it.font = .poppinsLight(fontSize: 12)
            it.numberOfLines = 0
            it.alpha = 0.6
        },spacing: Dimension.SIZE_4.cgFloat
    )
}
