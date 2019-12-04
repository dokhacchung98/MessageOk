//
//  FriendSentViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/18/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FriendSentViewModel {
    var listFR = BehaviorRelay<[FriendRequest]>(value: [])

    
    init() {
        self.getFriendRequest()
    }
    
    func getFriendRequest() {
        APIManager.requestData(url: "api/MyApi/GetAllFriendRequest", isLogin: true, method: .get, parameters: nil){ result in
            switch result {
            case .success(_, let body):
                print("Get Friend Request Body: \(String(describing: body))")
                var list:[FriendRequest] = []
                for item in (body?.array)!{
                    let u = FriendRequest(json: item)
                    list.append(u!)
                }
                self.listFR.accept(list)
                break
            case .failure(let err):
                print("Get Friend Request Error : \(err)")
                break
            }
        }
    }
    
    func repFriendRequest(id: String, isAccept: Bool) {
        var parameter: [String:Any] = [:]
        parameter["Id"] = id
        parameter["Accept"] = isAccept ? 1 : 0
        print("parameter reply: \(parameter)")
        APIManager.requestData(url: "api/MyApi/ReplyFR", isLogin: true, method: .post, parameters: parameter, completion: { result in
            switch (result) {
            case .success(_, _):
                print("Rep friend success")
                var list = self.listFR.value
                list.removeAll{$0.Id == id}
                self.listFR.accept(list)
                break
            case .failure(let err):
                print(("Error rep: \(err)"))
                break
            }
        })
    }
}
