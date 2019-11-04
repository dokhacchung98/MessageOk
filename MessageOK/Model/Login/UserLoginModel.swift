
//
//  UserLoginModel.swift
//  MessageOK
//
//  Created by Trung on 10/20/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation

class UserRegisterModel {
    var Email : String?
    var Password : String?
    var ConfirmPassword : String?
    
    init() {
        self.Email = ""
        self.Password = ""
        self.ConfirmPassword = ""
    }
    
    init(email:String, pass: String, confirmPass:String) {
        self.Email = email
        self.Password = pass
        self.ConfirmPassword = confirmPass
    }
    
    
    func toJson() -> [String:Any] {
        var para: [String:Any] = [:]
        para["Email"] = Email
        para["Password"] = Password
        para["ConfirmPassword"] = ConfirmPassword
        return para
    }
}

class UserLoginModel {
    var Username : String?
    var Password : String?
    var grant_type:String?
    
    init() {
        self.Username = ""
        self.Password = ""
        self.grant_type = "password"
    }
    
    init(user:String, pass:String) {
        grant_type = "password"
        self.Username = user
        self.Password =  pass
    }
    
    func toJson() -> [String:Any] {
        var para: [String:Any] = [:]
        para["Username"] = Username
        para["Password"] = Password
        para["grant_type"] = grant_type
        return para
    }
}

class ChangePassModel {
    var OldPassword:String?
    var NewPassword:String?
    var ConfirmPassword:String?
    
    init() {
    }
    
    init(oldPass:String, newPass:String, confirmPass:String) {
        self.OldPassword = oldPass
        self.NewPassword = newPass
        self.ConfirmPassword = confirmPass
    }
}

class LoginResultModel{
    var access_token:String?
    var token_type:String?
    var expires_in:Int64?
    var userName:String?
    
    init() {
    }
}
