//
//  AllReviewsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 10/11/2022.
//

import Foundation
import RxRelay

class AllReviewsViewModel : ViewModel{
    
    let allReviewsItems =  BehaviorRelay<[ReviewsItem]>(value: [])
       
}
