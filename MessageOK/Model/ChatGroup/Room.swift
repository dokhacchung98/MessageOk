//
//  Room.swift
//  MessageOK
//
//  Created by Trung on 11/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import SwiftyJSON

class Room:NSObject {
    enum Color:String {
        case Blue = "Blue"
        case Red = "Red"
        case Yellow = "Yellow"
    }
    enum Sticker:String {
        case Like = "Like"
        case Heart = "Heart"
        case Face = "Face"
    }
    
    var Id:String!
    var ColorRoom:Color! = .Blue
    var StickerRoom:Sticker! = .Like
    var NameRoom:String!
    var IsChatGroup:Bool!
    var LastContent:String?
    var PathAvatar:String?
    var UserJoinRooms:[UserJoinRoom]?
    
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
        self.ColorRoom = json["ColorRoom"].string.map { Room.Color(rawValue: $0)! }
        self.StickerRoom = json["StickerRoom"].string.map { Room.Sticker(rawValue: $0)! }
        self.NameRoom = json["NameRoom"].string
        self.IsChatGroup = json["IsChatGroup"].bool
        self.LastContent = json["LastContent"].string
        self.PathAvatar = json["PathAvatar"].string
        let arr = json["UserJoinRooms"].array
        for item in arr! {
            let tmp = UserJoinRoom(json: item)
            self.UserJoinRooms?.append(tmp!)
        }
    }
}
