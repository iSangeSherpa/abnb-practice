//
//  Sessions + Http Methods.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/11/2022.
//

import Foundation
import Alamofire
import RxSwift


enum RequestBody{
    case Data(Data)
    case Encodeable(Encodable)
    case Parameter(Parameters)
    case Empty
}


extension Session{
    private func buildUrlRequest(
        path:String,
        method:HTTPMethod,
        body:RequestBody,
        queryParams:Parameters = [:]
    ) throws ->  URLRequest {
        
        let url =  path.starts(with: "http")
        ?  try path.asURL()
        :  try Config.API_BASE_URL.asURL().appendingPathComponent(path)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//        urlComponents.queryItems = queryParams.map{ URLQueryItem(name: $0.key, value: $0.value) }
        
        var urlRequest =  try URLRequest(url: try urlComponents.asURL(), method: method)
        
        urlRequest = try URLEncoding().encode(urlRequest, with: queryParams)
        
        if(url.absoluteString.starts(with: Config.API_BASE_URL)){
            urlRequest.headers = defaultHeaders()
        }else{
            urlRequest.url = url
        }
        urlRequest.timeoutInterval = 300
        switch(body){
            
        case .Data(let data):
            urlRequest.httpBody = data
            break;
        case .Encodeable(let encodeable):
            urlRequest =  try! JSONEncoding().encode(urlRequest, withJSONObject: encodeable)
            break;
        case .Parameter(let parameters):
            urlRequest =  try! JSONEncoding().encode(urlRequest, with: parameters)
        case .Empty:
            break;
        }
        
        return urlRequest
    }
    
    func get<T: Decodable>(
        _ path:String,
        param:Parameters = [:]
    )->Single<T>{
        
        do{
            return request(try buildUrlRequest(
                path: path,
                method: .get,
                body: .Empty,
                queryParams: param
            ))
        }catch(let e){
            return Single.error(e)
        }
    }
    
    func post<T:Decodable>(
        _ path:String,
        body:RequestBody = .Empty,
        queryParams:Parameters = [:]
    )->Single<T>{
        do{
            return request(try buildUrlRequest(
                path: path,
                method: .post,
                body: body ,
                queryParams: queryParams
            ))
        }catch(let e){
            return Single.error(e)
        }
    }
    
    func post<T:Decodable>(
        _ path:String,
        body:Encodable,
        queryParams:Parameters = [:]
    )->Single<T>{
        post(path, body: .Encodeable(body), queryParams: queryParams)
    }
    
    func post<T:Decodable>(
        _ path:String,
        body:Parameters,
        queryParams:Parameters = [:]
    )->Single<T>{
        post(path, body: .Parameter(body), queryParams: queryParams)
    }
    
    
    func put<T:Decodable>(
        _ path:String,
        body:RequestBody = .Empty,
        queryParams:Parameters = [:]
    ) -> Single<T>{
        do{
            return request(try buildUrlRequest(
                path: path,
                method: .put,
                body: body ,
                queryParams: queryParams
            ))
        }catch(let e){
            return Single.error(Failure.UnknownError(e))
        }
    }
    
    func put<T:Decodable>(
        _ path:String,
        body:Data,
        queryParams:Parameters = [:]
    )->Single<T>{
        put(path, body: .Data(body), queryParams: queryParams)
    }
    
    func put<T:Decodable>(
        _ path:String,
        body:Encodable,
        queryParams: Parameters = [:]
    )->Single<T>{
        put(path, body: .Encodeable(body), queryParams: queryParams)
    }
    
    func put<T:Decodable>(
        _ path:String,
        body:Parameters,
        queryParams:Parameters = [:]
    )->Single<T>{
        put(path, body: .Parameter(body), queryParams: queryParams)
    }
    
    
    func patch<T:Decodable>(
        _ path:String,
        body:RequestBody = .Empty,
        queryParams:Parameters = [:]
    ) -> Single<T>{
        do{
            return request(try buildUrlRequest(
                path: path,
                method: .patch,
                body: body ,
                queryParams: queryParams
            ))
        }catch(let e){
            return Single.error(Failure.UnknownError(e))
        }
    }
    
    func patch<T:Decodable>(
        _ path:String,
        body:Encodable,
        queryParams:Parameters = [:]
    )->Single<T>{
        patch(path, body: .Encodeable(body), queryParams: queryParams)
    }
    
    func patch<T:Decodable>(
        _ path:String,
        body:Parameters,
        queryParams: Parameters = [:]
    )->Single<T>{
        patch(path, body: .Parameter(body), queryParams: queryParams)
    }
    
    func delete<T:Decodable>(
        _ path:String,
        body:RequestBody = .Empty,
        queryParams: Parameters = [:]
    ) -> Single<T>{
        do{
            return request(try buildUrlRequest(
                path: path,
                method: .delete,
                body: body ,
                queryParams: queryParams
            ))
        }catch(let e){
            return Single.error(Failure.UnknownError(e))
        }
    }
    
    func delete<T:Decodable>(
        _ path:String,
        body:Encodable,
        queryParams: Parameters = [:]
    )->Single<T>{
        delete(path, body: .Encodeable(body), queryParams: queryParams)
    }
    
    func delete<T:Decodable>(
        _ path:String,
        body:Parameters,
        queryParams: Parameters = [:]
    )->Single<T>{
        delete(path, body: .Parameter(body), queryParams: queryParams)
    }
    
    
    private func request<T : Decodable>(_ request:URLRequest)-> Single<T>{
        
        return  Single.create{ (observer: @escaping (SingleEvent<T>) -> Void) in
            
            let request = self.request(request)
            
            self.handleResponse(T.self,request){
                response in
                switch(response){
                case .success(let result):
                    observer(.success(result))
                    print(result)
                    break
                case .failure(let error):
                    if let error = error as? Failure{
                        if case .UnAuthenticatedError = error {
                            self.getNewAccessToken(){ tokenResult in
                                switch(tokenResult){
                                case .success(let accessToken):
                                    SessionManager.shared.accessToken = accessToken.token
                                    var updatedRequest = request.request
                                    if((updatedRequest?.url?.absoluteString ?? "" ).starts(with: Config.API_BASE_URL)){
                                        updatedRequest?.headers = defaultHeaders()
                                    }
                                    guard let urlDataRequest = updatedRequest else {
                                        observer(.failure(error))
                                        return
                                    }
                                    
                                    self.handleResponse(T.self,self.request(urlDataRequest)){
                                        response in
                                        switch(response){
                                        case .success(let result):
                                            observer(.success(result))
                                            break
                                        case .failure(let error):
                                            observer(.failure(error))
                                            break
                                        }
                                    }
                                    
                                    break
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        observer(.failure(Failure.UnAuthenticatedError))
                                    }
                                    
                                }
                                
                            }
                        }else{
                            observer(.failure(error))
                        }
                    }else{
                        observer(.failure(error))
                    }
                    break
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func handleResponse<T:Decodable>(_ t : T.Type,_ request:DataRequest,completion: @escaping (Result<T,Error>)->Void){
       
        request.validate(statusCode: 200...299).response()  { response in
            
            switch response.result{
                
            case .success(let value):
                
                if(T.self == Empty.self) {
                    completion(.success(Empty.emptyValue() as! T))
                }else{
                    do{
                        let response = try Config.jsonDecoder.decode(T.self, from: value!)
                        completion(.success(response))
                    }catch(let error){
                        #if DEBUG
                            print(error)
                        #endif
                        
                        if let data = response.data {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                let code = json["message"] as? String ?? Failure.UNKNOWN_STATUS_CODE
                                completion(.failure(Failure.ServerError(message: messageCodes[code]?.capitalizedFirstLetter ?? Failure.UNKNOWN_ERROR_MESSAGE, status: code )))
                            }else{
                                completion(.failure(Failure.UnknownError(error)))
                            }
                        }else{
                            completion(.failure(Failure.UnknownError(error)))
                        }
                    }
                }
            
                break
                
            case .failure(let error):
                #if DEBUG
                    print(error)
                #endif
                switch(response.response?.statusCode){
                case 401:
                    completion(.failure(Failure.UnAuthenticatedError))
                    break;
                    
                default:
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let code = json["message"] as? String ?? Failure.UNKNOWN_STATUS_CODE
                            completion(.failure(Failure.ServerError(message: messageCodes[code]?.capitalizedFirstLetter ?? Failure.UNKNOWN_ERROR_MESSAGE, status: code )))
                        }else{
                            completion(.failure(Failure.UnknownError(error)))
                        }
                    }else{
                        completion(.failure(Failure.UnknownError(error)))
                    }
                }
            }
        }
    }
    
    func getNewAccessToken(completion: @escaping (Result<AccessToken,Error>)->Void){
        
        let refreshToken = SessionManager.shared.refreshToken ?? ""
        let userId = SessionManager.shared.userId ?? ""
        
        let url = URL(string: "\(Config.API_BASE_URL)/users/\(userId)/access-tokens?refreshToken=\(refreshToken)")!

               let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                   guard let data = data else {
                       completion(.failure("Error"))
                       return }
                   print("The response is : ",String(data: data, encoding: .utf8)!)
                   
                   do{
                       let result = try JSONDecoder().decode(BaseResponse<AccessToken>.self, from: data)
                       DispatchQueue.main.async {
                           completion(.success(result.data))
                       }
                   }catch{
                       completion(.failure(error))
                   }
               }
               task.resume()
    }

}
