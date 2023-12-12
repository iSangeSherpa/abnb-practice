//
//  AcceptTermsViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 06/03/2023.
//

import Foundation
import RxRelay

class AcceptTermsViewModel : ViewModel{
    let onTermsActionPerformed = PublishRelay<Bool>()
}
