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
    var MessType = TypeMessage.Text.rawValue
    var PathImage:String?
    var PathVideo:String?
    var EmojiId:String?
    
    init() {
    }
    
    init(MessType:Int, ContentText:String?, EmojiId:String?, PathImage:String?, PathVideo:String?) {
        self.MessType = MessType
        	
    }
}

enum TypeMessage : Int {
    case Text = 1
    case Icon = 2
    case Image = 3
    case Video = 4
}
