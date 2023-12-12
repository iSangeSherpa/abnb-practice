//
//  DocumentResponse.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 30/11/2022.
//

import Foundation
import UIKit
import Differentiator

struct DocumentDetails : Codable{
    var id : String
    var type : UserDocumentType
    var documentId: String
    var issuePlace: String
    var files: [String]?
    var approvalStatus : ApprovalStatus?
}

extension DocumentDetails{
    static func == (lhs: DocumentDetails, rhs: DocumentDetails) -> Bool {
        return lhs.id  == rhs.id
    }
}

extension DocumentDetails : Equatable {}

extension DocumentDetails :  IdentifiableType {
    var identity: String{
        return self.id
    }
}
