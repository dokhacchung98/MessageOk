//
//  ChatViewModel.swift
//  MessageOK
//
//  Created by Trung on 12/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import Firebase

class ChatViewModel {
    
    var listMessage = BehaviorRelay<[MessageModel]>(value: [])
    var idRoom:String!
    var idUser:String!
    var message:MessageModel?
    var pathImage = BehaviorRelay<String>(value: "")
    var nickName = BehaviorRelay<String>(value: "")
    var isOnline = BehaviorRelay<Bool>(value: false)
    
    init(idRoom:String) {
        self.idRoom = idRoom
        self.idUser = (MyUserDefault.instance.getObject(key: .UserId) as! String)
        self.getMessage()
        self.getRoom()
    }
    
    func observerMessages() {
        let ref = Database.database().reference().child(APIManager.ROOM_NAME).child(idRoom)
        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            //value added
            if let dictionary = snapshot.value as? [String: Any] {
                let mes = MessageModel()
                mes.ContentText = dictionary["ContentText"] as? String ?? ""
                mes.EmojiId = dictionary["EmojiId"] as? String ?? ""
                mes.MessType = dictionary["MessType"] as? TypeMessage ?? TypeMessage.Text
                mes.PathImage = dictionary["PathImage"] as? String ?? ""
                mes.PathVideo = dictionary["PathVideo"] as? String ?? ""
                mes.Time = dictionary["Time"] as? Int as NSNumber? ?? 0 as NSNumber
                self.listMessage.accept(self.listMessage.value + [mes])
            }
        }, withCancel: nil)
    }
    
    func getRoom() {
        let para = ["idRoom" : idRoom!]
        APIManager.requestData(url: "api/MyApi/GetRoom", isLogin: true, method: .get, parameters: para as APIManager.parameters) { result in
            switch(result) {
            case .success(_, let body):
                let room = Room(json: body)
                var user:UserJoinRoom?
                for item in room!.UserJoinRooms {
                    if item.UserId != self.idUser {
                        user = item
                        break
                    }
                }
                if user != nil {
                    self.pathImage.accept(user!._User.Avatar!)
                    self.nickName.accept(user!.NickName)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getMessage() {
        let ref = Database.database().reference().child(APIManager.ROOM_NAME).child(self.idRoom)
        
        ref.observe(.value) { snapshot in
            if snapshot.childrenCount > 0 {
                var list:[MessageModel] = []
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                                let value = item.value as? NSDictionary
                                let id = value?["UserId"] as? String ?? ""
                                let content = value?["ContentText"] as? String ?? ""
                                let type = TypeMessage(rawValue:  value?["MessType"] as? Int ?? 1)
                                let emoji = value?["EmojiId"] as? String ?? ""
                                let image = value?["PathImage"] as? String ?? ""
                                let video = value?["PathVideo"] as? String ?? ""
                                let time = value?["Time"] as? NSNumber ?? 0
                    let mes = MessageModel(MessType: type!, ContentText: content, EmojiId: emoji, PathImage: image, PathVideo: video)
                                mes.UserId = id
                                mes.Time = time
                    print(mes.ContentText)
                    list.append(mes)
                }
                self.listMessage.accept(list)
            }
        }
    }
    
    func sendImageMessage(image:UIImage) {
        let key = Database.database().reference().childByAutoId().key
        APIManager.uploadImage(image,key ?? "imahh") { url in
            if let myUrl = url {
                self.createMess(Content: nil, EmojiId: nil, PathImage: myUrl.absoluteString, PathVideo: nil)
            }
        }
    }
    
    func sendEmojiMessage(path: String) {
        self.createMess(Content: nil, EmojiId: path, PathImage: nil, PathVideo: nil)
    }
    
    func sendMessage() {
        if let mes = message {
            APIManager.sendMessage(idRoom: self.idRoom!, message: mes)
        }
    }
    
    func createMess(Content:String?, EmojiId:String?, PathImage:String?, PathVideo:String?) {
        if let _emoji = EmojiId {
            message = MessageModel()
            message?.MessType = .Icon
            message?.EmojiId = _emoji
        } else if let _content = Content {
            message = MessageModel()
            message?.MessType = .Text
            message?.ContentText = _content
        } else if let _image = PathImage {
            message = MessageModel()
            message?.MessType = .Image
            message?.PathImage = _image
        } else if let _video = PathVideo {
            message = MessageModel()
            message?.MessType = .Text
            message?.PathVideo = _video
        }
        sendMessage()
    }
}
