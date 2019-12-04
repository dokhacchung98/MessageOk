//
//  User.swift
//  MessageOK
//
//  Created by Trung on 11/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {
    var Avatar:String?
    var Wallpaper:String?
    var Address:String?
    var FullName:String?
    var DoB:Date?
    var Phone:String?
    var Email:String?
    var Id:String?
    var UserName:String?
    
    convenience init?(jsonObject: Any?) {
        guard let jsonData = jsonObject else { return nil }
        self.init()
        
        let json = JSON(jsonData)
        self.parseJson(json)
    }
    
    convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        
        self.parseJson(_json)
    }
    
    private func parseJson(_ json: JSON) {
        self.Avatar = json["Avatar"].string
        self.Wallpaper = json["Wallpaper"].string
        self.Address = json["Address"].string
//        self.DoB = json[""]
        self.FullName = json["FullName"].string
        self.Phone = json["Phone"].string
        self.Email = json["Email"].string
        self.Id = json["Id"].string
        self.UserName = json["UserName"].string
    }
}
