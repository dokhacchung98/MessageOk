//
//  SplashScreenViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/4/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SplashScreenViewModel {
    enum statusAccount {
        case login
        case addInforStart
        case home
        case none
    }
    
    var statusAccountLogin = BehaviorRelay<statusAccount>(value: .none)
    var isCountDownFinish = BehaviorRelay<Bool>(value: false)
    
    var isLoadingFinish:Observable<Bool>{
        let isFinishRequest = self.statusAccountLogin.asObservable().map({ value in
            return value != .none })
        return Observable.combineLatest(isFinishRequest, self.isCountDownFinish.asObservable().map({t in
            return t
        })){ $0 && $1 }
    }
    
    var disposeBag = DisposeBag()
    var myUserDefault = MyUserDefault.instance
    
    init() {
        self.checkIsSaveOldAccount()
    }
    
    private func checkIsSaveOldAccount(){
        if let _ = myUserDefault.getObject(key: .Token){
            APIManager.requestData(url: "GetUserLogin", isLogin: true, method: .get, parameters: nil) { result in
                switch result{
                case .success(_, let body):
                    let idUserRequest = body!["Id"].rawValue as! String
                    let fullName:String? = body!["FullName"].rawValue as? String ?? ""
                    self.myUserDefault.saveObject(value: idUserRequest, key: .UserId)

                    if fullName != "" {
                        self.statusAccountLogin.accept(.home)
                    }else{
                        self.statusAccountLogin.accept(.addInforStart)
                    }
                    break
                case .failure(_):
                    self.statusAccountLogin.accept(.login)
                    break
                }
            }
        }else{
            self.statusAccountLogin.accept(.login)
        }
    }
}
