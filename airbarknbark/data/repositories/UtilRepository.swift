//
//  BasicRepository.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 23/11/2022.
//

import Foundation
import RxSwift

enum FileType {
    case PROFILE_PICTURE
    case PETS
    case OTHER
}

protocol UtilRepostiory {
    func uploadFile(fileData: Data,fileName: String, type: FileType) -> Single<FileUploadDetails>
}

class UtilRepositoryImpl : UtilRepostiory{
    func uploadFile(fileData: Data,fileName: String, type: FileType) -> Single<FileUploadDetails>{
        
        return ApiService.getPresignedUrl(fileName: fileName, type: String(describing: type))
            .flatMap{ it in
                ApiService.uplaodFile(url: it.data.url, data: fileData)
                    .map { _ in
                        it.data
                    }
            }
    }
}
