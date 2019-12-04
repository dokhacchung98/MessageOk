//
//  UserJoinRoom.swift
//  MessageOK
//
//  Created by Trung on 11/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserJoinRoom: NSObject {
    var UserId:String?
    var Id:String?
    var NickName:String!
    var RoomId:String!
    var _User:User!
    var LastInterractive:Date?
    
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
        self.Id = json["Id"].string
        self.NickName = json["NickName"].string
        self.RoomId = json["RoomId"].string
        self.UserId = json["UserId"].string
        self._User = User(jsonObject: json["User"].object)
    }
}
