//
//  Emoji.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import SwiftyJSON

class Emoji:NSObject {
    var NameEmoji:String?
    var PathImage:String?
    var Id:String?
    
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
        self.NameEmoji = json["NameEmoji"].string
        self.PathImage = json["PathImage"].string
        self.Id = json["Id"].string
    }
}
