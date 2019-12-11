//
//  TypeEmoji.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import SwiftyJSON

class TypeEmoji:NSObject {
    var NameType:String?
    var PathThumbnail:String?
    var Id:String?
    var Emojis:[Emoji] = []
    
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
        self.NameType = json["NameType"].string
        self.PathThumbnail = json["PathThumbnail"].string
        self.Id = json["Id"].string
        for j in json["Emojis"].array! {
            let tmp = Emoji(jsonObject: j.object)
            self.Emojis.append(tmp!)
        }
    }
}
