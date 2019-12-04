//
//  UserListViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/14/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserListViewModel {
    var listUser = BehaviorRelay<[User]>(value: [])
    var currentIndex = 0
    
    init() {
        self.getUser()
    }
    
    func getUser() {
        var parameter:[String:Any] = [:]
        parameter["pageNumber"] = currentIndex += 1
        parameter["pageSize"] = 10
        APIManager.requestData(url: "api/MyApi/GetListUser", isLogin: true, method: .get, parameters: parameter){ result in
            switch result {
            case .success(_, let body):
                var list:[User] = []
                for item in (body?.array)!{
                    let u = User(json: item)
                    list.append(u!)
                }
                self.listUser.accept(list)
                break
            case .failure(let err):
                    print("Get User Error : \(err)")
                break
            }
        }
    }
}
