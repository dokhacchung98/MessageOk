//
//  Network.swift
//  MessageOK
//
//  Created by Trung on 10/27/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class APIManager {
    static var Base_Url_Account = "http://khacchung98.somee.com/"
    static var Base_Url = "http://khacchung98.somee.com/api/MyApi/"
    
    typealias parameters = [String:Any]
    
    enum ApiResult {
        case success(JSON)
        case failure(RequestError)
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    static func requestData(url:String, isLogin:Bool, method:HTTPMethod, parameters:parameters?, completion: @escaping (ApiResult)->Void) {
        
        var header = ["":""];
        if(isLogin){
            header = ["Content-Type": "application/x-www-form-urlencoded"]
        }else{
            header = ["Content-Type": "application/json"]
        }
        var myUrl = ""
        if(isLogin){
            myUrl = Base_Url
        }else{
            myUrl = Base_Url_Account
        }
        
        var urlRequest = URLRequest(url: URL(string: myUrl)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        if let parameters = parameters {
            let parameterData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
                }.data(using: .utf8)
            urlRequest.httpBody = parameterData
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data, options: .allowFragments)
                    print("responseCode : \(responseCode.statusCode)")
                    print("responseJSON : \(responseJson)")
                    switch responseCode.statusCode {
                    case 200:
                        completion(ApiResult.success(responseJson))
                    case 400...499:
                        completion(ApiResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                        completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                }
                catch let parseJSONError {
                    completion(ApiResult.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJSONError)")
                }
            }
            }.resume()
    }
}
