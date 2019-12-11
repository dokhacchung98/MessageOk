//
//  MessageModel.swift
//  MessageOK
//
//  Created by Trung on 12/4/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation

class MessageModel {
    var ContentText:String?
    var MessType = TypeMessage.Text
    var PathImage:String?
    var PathVideo:String?
    var EmojiId:String?
    var Time:NSNumber?
    var UserId:String?
    
    init() {
        
    }
    
    init(MessType:TypeMessage, ContentText:String?, EmojiId:String?, PathImage:String?, PathVideo:String?) {
        self.MessType = MessType
        self.ContentText = ContentText
        self.EmojiId = EmojiId
        self.PathImage = PathImage
        self.PathVideo = PathVideo
    }
    
    func toJSON() -> Dictionary<String, Any> {
        if let userId = (MyUserDefault.instance.getObject(key: .UserId) as? String) {
            return [
                "MessType": self.MessType.rawValue,
                "ContentText": self.ContentText ?? "",
                "EmojiId": self.EmojiId ?? "",
                "PathImage": self.PathImage ?? "",
                "PathVideo": self.PathVideo ?? "",
                "Time": Int(NSDate().timeIntervalSince1970),
                "UserId": userId
            ]
        }
        return [:]
    }
}

enum TypeMessage : Int {
    case Text = 1
    case Icon = 2
    case Image = 3
    case Video = 4
}
