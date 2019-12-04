//
//  SettingViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingViewModel {
    var isLogoutSuccess = BehaviorRelay<Bool>(value: false)
    
    func logoutAccount() {
        APIManager.requestData(url: "api/Account/Logout", isLogin: true, method: .post, parameters: nil, completion: { result in
            switch (result){
                case .success(_, _):
                    self.isLogoutSuccess.accept(true)
                    break
                case .failure(let err):
                    print("Error logout: \(err)")
                    break
                }
            })
    }
}
