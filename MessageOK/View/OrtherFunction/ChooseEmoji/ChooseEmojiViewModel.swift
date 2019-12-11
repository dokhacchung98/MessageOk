//
//  ChooseEmojiViewModel.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChooseEmojiViewModel {
    var listType = BehaviorRelay<[TypeEmoji]>(value: [])
    var listShow = BehaviorRelay<[MyEmoji]>(value: [])
    
    init() {
        _ = listType.bind(onNext: { values in
            self.getTypeShow()
        })
        self.getListType()
    }
    
    func getTypeShow() {
        var list:[MyEmoji] = []
        for item in listType.value {
            let tmp = MyEmoji(Id: item.Id, Path: item.PathThumbnail)
            list.append(tmp)
        }
        self.listShow.accept(list)
    }
    
    func getEmojiShow(id:String) {
        var list:[MyEmoji] = []
        var currentType:TypeEmoji = TypeEmoji()
        
        for t in listType.value {
            if t.Id == id {
                currentType = t
                break
            }
        }
        
        for item in currentType.Emojis {
            let tmp = MyEmoji(Id: item.Id, Path: item.PathImage)
            list.append(tmp)
        }
        self.listShow.accept(list)
    }
    
    func getListType() {
        APIManager.requestData(url: "api/MyApi/GetTypeEmoji", isLogin: true, method: .get, parameters: nil) { (result) in
            switch result {
            case .success(_, let body):
                var list:[TypeEmoji] = []
                for item in (body?.array)! {
                    list.append(TypeEmoji(json: item)!)
                }
                self.listType.accept(list)
                break
            case .failure(_):
                break
            }
        }
    }
}

class MyEmoji {
    var Id:String?
    var Path:String?
    
    init() {
        
    }
    
    init(Id:String?, Path:String?) {
        self.Id = Id
        self.Path = Path
    }
}
