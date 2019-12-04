//
//  FriendRequest.swift
//  MessageOK
//
//  Created by Trung on 11/18/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import SwiftyJSON

class FriendRequest:NSObject {
    var Content:String?
    var UserSend:String?
    var UserId:String?
    var Id:String?
    var _User:User?
    
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
        self.Content = json["Content"].string
        self.UserSend = json["UserSend"].string
        self.UserId = json["UserId"].string
        self.Id = json["Id"].string
        self._User = User(jsonObject: json["User"].object)
    }
}
