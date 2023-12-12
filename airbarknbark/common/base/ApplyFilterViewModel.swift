//
//  ApplyFilterViewModel.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 29/12/2022.
//

import Foundation
import RxRelay

enum FindersPreference : String, CaseIterable{
    case WITH_PET
    case WITHOUT_PET
}

struct FilterParams {
    let findersPreference : FindersPreference?
    let gender : Gender?
    let maxDistance : Int
    
}
class ApplyFilterViewModel : ViewModel{
    let onSearchClicked = PublishRelay<FilterParams>()
    let gender = BehaviorRelay<Gender?>(value: nil)
    let findersPreference = BehaviorRelay<FindersPreference?>(value: nil)
    let maxDistance = BehaviorRelay<Int>(value: Config.MAP_LOCATION_FILTER_MAX_RADIUS)
    let onDistanceSliderChange = PublishRelay<Void>()
 
    
    func setFilterParams(filterParams : FilterParams?){
        guard let filterParams = filterParams  else {return}
        
        gender.accept(filterParams.gender)
        findersPreference.accept(filterParams.findersPreference)
        maxDistance.accept(filterParams.maxDistance)
    }
    
    func applyFiltersAndSearch(){
        onSearchClicked.accept(FilterParams(findersPreference: findersPreference.value, gender: gender.value, maxDistance: maxDistance.value))
    }
}
