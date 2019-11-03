//
//  MyUserDefault.swift
//  MessageOK
//
//  Created by Trung on 11/1/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation


class MyUserDefault{
    
    static let instance:MyUserDefault = MyUserDefault()
    
    private let userDefault: UserDefaults!
    
    enum KeySave:String {
        case Token = "Token"
        case TokenType = "tokentype"
        case UserName = "userName"
        case Email = "Email"
        case Password = "Password"
    }
    
    init() {
        userDefault = UserDefaults.standard
    }
    
    func saveObject(value:Any, key: KeySave){
        userDefault.set(value, forKey: key.rawValue)
    }
    
    func getObject(key: KeySave) -> Any?{
        return userDefault.value(forKey: key.rawValue)
    }
    
    func removeObject(key: KeySave){
        userDefault.removeObject(forKey: key.rawValue)
    }
    
    func editObject(value:Any, key: KeySave){
        removeObject(key: key)
        saveObject(value: value, key: key)
    }
}
