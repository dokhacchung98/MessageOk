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
    
    private var myUserDefault : MyUserDefault = MyUserDefault.instance
    
    var loginUserInput = BehaviorRelay<String>(value: "")
    var loginPassInput = BehaviorRelay<String>(value: "")
    
    var regisEmailInput = BehaviorRelay<String>(value: "")
    var regisPassInput = BehaviorRelay<String>(value: "")
    var messageError = BehaviorRelay<String>(value: "")
    var regisPassConfirmInput = BehaviorRelay<String>(value: "")

    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var tapLogin: Observable<Void>
    var tapRegister: Observable<Void>
    
    enum TypeLogin {
        case success
        case faild
        case updateInformation
        case none
    }
    
    var isLoginSuccessful = BehaviorRelay<TypeLogin>(value: .none)
    var isRegisterSuccessful = BehaviorRelay<Bool>(value: false)
    
    var isValidInputLogin : Observable<Bool>{
        let userValid = loginUserInput.asObservable().map{ loginModel in
            return loginModel.isValidEmail
        }
        
        let passValid = loginPassInput.asObservable().map{ loginModel in
            return loginModel.count >= 6
        }
        
        return Observable.combineLatest(userValid, passValid, isLoading.asObservable().map{ t in
            return t
        }) {$0 && $1 && !$2}
    }
    
    var isValidInputRegister : Observable<Bool>{
        let email = self.regisEmailInput.asObservable().map{ mail in
            return mail.isValidEmail
        }
        
        let pass = self.regisPassInput.asObservable().map{ pass in
            return pass.count >= 6
        }
        
        let passConfirm = self.regisPassConfirmInput.asObservable().map{ passc in
            return passc.count >= 6
        }
        
        return Observable.combineLatest(email, pass, passConfirm, isLoading.asObservable().map({ t in
            return t
        })) { $0 && $1 && $2 && !$3}
     }
    
    init(tapLogin :Observable<Void>, tapRegister:Observable<Void>) {
        self.tapLogin = tapLogin
        self.tapRegister = tapRegister
        
        _ = self.tapRegister.bind(onNext: { _ in
            self.register(UserRegisterModel(email: self.regisEmailInput.value, pass: self.regisPassInput.value, confirmPass: self.regisPassConfirmInput.value))
        })
        
        _ = self.tapLogin.bind(onNext: {_ in
            self.login(UserLoginModel(user: self.loginUserInput.value, pass: self.loginPassInput.value))
        })
    }
    
    private func register(_ registerModel: UserRegisterModel){
        self.isLoading.accept(true)
        APIManager.requestData(url: "api/Account/Register", isLogin: false, method: .post, parameters: registerModel.toJson()) { Result in
            switch Result{
                case .success(_, let body):
                    self.isLoading.accept(false)
                    print("Register result: \(body!)")
                    self.isRegisterSuccessful.accept(true)
                    self.messageError.accept("")
                    break
                case .failure(let faild):
                    self.isLoading.accept(false)
                    self.isRegisterSuccessful.accept(false)
                    self.messageError.accept("Error: \(faild)")
            }
        }
    }
    
    private func login(_ loginModel: UserLoginModel) {
        self.isLoading.accept(true)
        APIManager.requestData(url: "token", isLogin: false, method: .post, parameters: loginModel.toJson(), completion: { result in
            switch result {
                case .success(_ , let body) :
                    print("Vale token: \(body!["access_token"])")
                    self.myUserDefault.saveObject(value: body!["access_token"].rawValue, key: .Token)
                    self.myUserDefault.editObject(value: body!["token_type"].rawValue, key: .TokenType)
                    self.myUserDefault.saveObject(value: body!["userName"].rawValue, key: .UserName)
                    self.checkInformationUserIsEmpty()
                    break
                case .failure(let failure) :
                  print("Error \(failure)")
                  self.isLoading.accept(false)
                  self.isLoginSuccessful.accept(.faild)
                  self.messageError.accept("Error: \(failure)")
            }
        })
    }
    
    private func checkInformationUserIsEmpty(){
        APIManager.requestData(url: "api/MyApi/GetUserLogin", isLogin: true, method: .get, parameters: nil) { result in
            switch result{
            case .success(_, let body):
                let idUserRequest = body!["Id"].rawValue as! String
                let fullName:String? = body!["FullName"].rawValue as? String ?? ""
                self.myUserDefault.saveObject(value: idUserRequest, key: .UserId)
                
                if fullName != "" {
                    self.myUserDefault.saveObject(value: body!["Email"].rawValue, key: .Email)
                    self.myUserDefault.saveObject(value: body!["Avatar"].rawValue, key: .Avatar)
                    self.myUserDefault.saveObject(value: body!["FullName"].rawValue, key: .FullName)
                    self.myUserDefault.saveObject(value: body!["DoB"].rawValue, key: .BoB)
                    self.myUserDefault.saveObject(value: body!["Address"].rawValue, key: .Address)
                    self.myUserDefault.saveObject(value: body?["Wallpaper"].rawValue ?? "", key: .Wallpaper)
                    self.myUserDefault.saveObject(value: body!["Phone"].rawValue, key: .Phone)
                    self.isLoginSuccessful.accept(.success)
                }else{
                    self.isLoginSuccessful.accept(.updateInformation)
                }
                self.isLoading.accept(false)
                self.messageError.accept("")
                break
            case .failure(_):
                self.isLoginSuccessful.accept(.faild)
                break
            }
        }
    }
}
