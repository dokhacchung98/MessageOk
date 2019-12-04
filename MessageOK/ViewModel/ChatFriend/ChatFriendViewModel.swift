//
//  ChatFriendViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/19/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class ChatFriendViewModel {
    
    var listUserJoinRoom = BehaviorRelay<[UserJoinRoom]>(value: [])
    var currentPage = 0
    var pageTotalSize = 0
    var pageSize = 10
    
    init() {
        self.loadUserJoinRoom()
    }
    
    private func loadUserJoinRoom() {
        var parameter: [String:Any] = [:]
        parameter["pageNumber"] = currentPage += 1
        parameter["pageSize"] = pageTotalSize += pageSize
        APIManager.requestData(url: "api/MyApi/GetListUserJoinRoom", isLogin: true, method: .get
            , parameters: parameter, completion: { result in
                switch (result) {
                case .success(_, let body):
                    var list: [UserJoinRoom] = []
                    for item in (body?.array)! {
                        list.append(UserJoinRoom(json: item)!)
                    }
                    self.listUserJoinRoom.accept(list)
                    break
                case .failure(let err):
                    print("Error get list user join room: \(err)")
                    break
                }
        })
    }
}
