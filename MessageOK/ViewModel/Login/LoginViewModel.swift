//
//  LoginViewModel.swift
//  MessageOK
//
//  Created by Trung on 10/27/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel{
    
    public enum LoginError{
        case internetError(String)
        case serverMessage(String)
    }
    
    private let disposable =  DisposeBag()
    
    var loginUserInput = BehaviorRelay<String>(value: "")
    var loginPassInput = BehaviorRelay<String>(value: "")
    var registerInput = BehaviorRelay<UserRegisterModel>(value: UserRegisterModel())
    
    var tapLogin: Observable<Void>
    
    var isLoginSuccessful = BehaviorRelay<Bool>(value: false)
    
    var isValidInputLogin : Observable<Bool>{
        let userValid = loginUserInput.asObservable().map{ loginModel in
            return loginModel.isValidEmail
        }
        
        let passValid = loginPassInput.asObservable().map{ loginModel in
            return loginModel.count >= 6
        }
        
        return Observable.combineLatest(userValid, passValid) {$0 && $1}
    }
    
    var isRequest = PublishSubject<Bool>()
    
    init(tapLogin :Observable<Void>) {
        self.tapLogin = tapLogin
        
        _ = self.tapLogin.bind(onNext: {_ in
            self.login(UserLoginModel(user: self.loginUserInput.value, pass: self.loginPassInput.value))
        })
    }
    
    private func register(_ registerModel: UserRegisterModel){
        self.isRequest.onNext(true)
    }
    
    private func login(_ loginModel: UserLoginModel){
        print("func login is calling with data \(loginModel.toJson())")
        self.isRequest.onNext(true)
        APIManager.requestData(url: "token", isLogin: false, method: .post, parameters: ["Username":"ochung3@gmail.com", "Password":"123456", "grant_type":"password"], completion: { (result) in
            switch result {
            case .success(let returnJson) : break
            case .failure(let failure) :
              print("Error \(failure)")
            }
        })
    }
}

//["Username":"ochung3@gmail.com", "Password":"123456", "grant_type":"password"]
