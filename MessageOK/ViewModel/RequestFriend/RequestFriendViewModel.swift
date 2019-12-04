//
//  RequestFriendViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class RequestFriendViewModel {
    var roomGroup = BehaviorRelay<[Room]>(value: [])
    var numberPage = 0
    var canNextPage = true
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
//        self.loadMoreGroupRoom()
    }
    
    func loadMoreGroupRoom() {
        if canNextPage {
            var parameter: [String:Any] = [:]
            parameter["pageNumber"] = self.numberPage += 1
            parameter["pageSize"] = 10
            
            APIManager.requestData(url: "api/MyApi/GetListUser", isLogin: true, method: .get, parameters: parameter, completion: { result in
                switch (result){
                case .success(var header, let body):
                    header = header!["Paging-Headers"]
                    self.canNextPage = header!["nextPage"].int == 1
                    break
                case .failure(let err):
                    print("Error get group room: \(err)")
                    break
                }
            })
        }
    }
    
    func loadFriendRequest() {
        if canNextPage {
            var parameter: [String:Any] = [:]
            parameter["pageNumber"] = self.numberPage += 1
            parameter["pageSize"] = 10
            
            APIManager.requestData(url: "api/MyApi/GetAllFriendRequest", isLogin: true, method: .get, parameters: parameter, completion: { result in
                switch (result){
                case .success(var header, let body):
                    header = header!["Paging-Headers"]
                    self.canNextPage = header!["nextPage"].int == 1
                    break
                case .failure(let err):
                    print("Error get group room: \(err)")
                    break
                }
            })
        }
    }
}
