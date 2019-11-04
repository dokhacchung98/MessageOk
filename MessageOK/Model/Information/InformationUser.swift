//
//  InformationUser.swift
//  MessageOK
//
//  Created by Trung on 11/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation

class InformationUSer {
    var UserId:String?
    var FullName:String?
    var Address:String?
    var Phone:String?
    var DoB:Date?
    
    init() {
    }
    
    init(UserId:String, FullName:String, Address:String, Phone:String, DoB:Date) {
        self.UserId = UserId
        self.FullName = FullName
        self.Address = Address
        self.Phone = Phone
        self.DoB = DoB
    }
    
    func toJson() -> [String:Any] {
        var para: [String:Any] = [:]
        para["UserId"] = UserId
        para["FullName"] = FullName
        para["Address"] = Address
        para["Phone"] = Phone
        para["DoB"] = DoB
        return para
    }
}
