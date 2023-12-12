//
//  Reponse.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 22/11/2022.
//

import Foundation

//struct Empty : Codable{
//    
//}

struct BaseResponse<T : Decodable> : Decodable{
    var data : T
}

