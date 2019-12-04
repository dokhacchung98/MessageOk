//
//  ChatGroupViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class ChatGroupViewModel {
    var roomGroup = BehaviorRelay<[Room]>(value: [])
    var numberPage = 0
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    func loadMoreGroupRoom() {
        var parameter: [String:Any] = [:]
        parameter["pageNumber"] = self.numberPage += 1
        parameter["pageSize"] = 10
        
        APIManager.requestData(url: "api/MyApi/GetAllGroup", isLogin: true, method: .get, parameters: nil, completion: { result in
            switch (result){
                case .success(let header, let body):
                    
                    break
                case .failure(let err):
                    print("Error get group room: \(err)")
                    break
            }
        })
    }
}
