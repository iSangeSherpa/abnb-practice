//
//  Legands.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 09/01/2023.
//

import Foundation
import UIKit

func MapLegandItem(_ label:String, _ color:UIColor)->UIView{
    return hstack(
        HSpacer(10).apply{ it in
            it.backgroundColor = color
        },
        Caption(label: label, textAlignment: .left),
        spacing:6
    ).withSize(.init(width: 60, height: 10))
}


func MapLegands() -> UIView {
    
    return stack(
        MapLegandItem("Minder", ActiveProfile.MINDER.getColor()),
        MapLegandItem("Finder", ActiveProfile.FINDER.getColor()),
        MapLegandItem("Both", ActiveProfile.BOTH.getColor()),
        spacing:4
    )
}
