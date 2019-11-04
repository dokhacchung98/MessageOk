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
import Alamofire
import FirebaseStorage

class APIManager {
    static var Base_Url_Account = "http://khacchung98.somee.com/"
    static var Base_Url = "http://khacchung98.somee.com/api/MyApi/"
    
    typealias parameters = [String:Any]
    
    enum ApiResult {
        case success(JSON?, JSON?)
        case failure(RequestError)
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
            let typeToken = MyUserDefault.instance.getObject(key: .TokenType) as! String
            let token = MyUserDefault.instance.getObject(key: .Token) as! String
            header = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "\(String(describing: typeToken)) \(String(describing: token))"]
            print("Header: \(header)")
        }else{
            header = ["Content-Type": "application/x-www-form-urlencoded"]
        }
        var myUrl = ""
        if(isLogin){
            myUrl = Base_Url + url
        }else{
            myUrl = Base_Url_Account + url
        }
        
        Alamofire.request(myUrl, method: method, parameters: parameters, encoding: method == HTTPMethod.get ? URLEncoding.queryString : URLEncoding.httpBody, headers: header)
                 .validate(contentType: ["application/json"])
                 .responseJSON { response in
                    let headersResponse = response.response?.allHeaderFields as? [String: String]
                    print("header result: \(String(describing: headersResponse)))")
                    print("respone result: \(String(describing: response.result.value))")
                    print("error result: \(String(describing: response.result.error))")
                    let statusCode = (response.response?.statusCode)!
                    
                    switch statusCode{
                    case 200:
                        completion(ApiResult.success(JSON(headersResponse!), response.result.value != nil ? JSON(response.result.value!) : JSON()))
                    case 400...499:
                        completion(ApiResult.failure(.authorizationError(response.result.value != nil ? JSON(response.result.value!) : JSON())))
                    case 500...599:
                        completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
        }
    }
    
    static func uploadImage(_ image:UIImage, _ nameImage: String, completion: @escaping ((_ url: URL?)->())){
        let storageRef = Storage.storage().reference().child(nameImage + ".png")
        let imageData = image.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imageData!, metadata: metaData){ (metadata, err) in
            if err == nil{
                print("Upload image success")
                storageRef.downloadURL(completion: { (url, err) in
                    completion(url)
                })
            }else{
                completion(nil)
                print("Upload image error : \(String(describing: err))")
            }
        }
    }
}
