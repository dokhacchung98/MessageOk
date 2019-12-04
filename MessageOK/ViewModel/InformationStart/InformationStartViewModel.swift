//
//  InformationStartViewModel.swift
//  MessageOK
//
//  Created by Trung on 11/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class InformationStartViewModel {
    var userId = BehaviorRelay<String>(value: "")
    var name = BehaviorRelay<String>(value: "")
    var birth = BehaviorRelay<Date>(value: Date())
    var phone = BehaviorRelay<String>(value: "")
    var address = BehaviorRelay<String>(value: "")
    var imageAvatar : UIImageView?
    var imageWallpaper : UIImageView?
    var isRequest = BehaviorRelay<Bool>(value: false)
    var error = BehaviorRelay<String>(value: "")
    var isUpdateSuccess = BehaviorRelay<Bool>(value: false)
    
    var buttonUpdate:Observable<Void>
    
    init(imageView:UIImageView, imageWallView:UIImageView, buttonUpdate: Observable<Void>) {
        self.imageAvatar = imageView
        self.imageWallpaper = imageWallView
        self.buttonUpdate = buttonUpdate

        let userId = MyUserDefault.instance.getObject(key: .UserId) as? String ?? ""
        print("Get User Id: \(userId)")
        self.userId.accept(userId)
        
        _ = self.buttonUpdate.bind{ _ in
            self.isRequest.accept(true)
            self.uploadImage()
        }
    }
    
    let calendar = Calendar.current

    var isValid: Observable<Bool>{
        let isValidName = self.name.asObservable().map{ name in
            return name.count > 2
        }
        let isValidAge = self.birth.asObservable().map{ date in
            return self.calendar.component(.year,
                                      from: self.birth.value) >= 0
        }
        let isValidPhone = self.phone.asObservable().map{ phone in
            return phone.count > 7 && phone.count < 12
        }
        let isVaildAddress = self.address.asObservable().map{ address in
            return address.count > 0
        }
        return Observable.combineLatest(isValidAge, isValidName, isValidPhone, isVaildAddress, isRequest.asObservable().map{ t in
            return t
        } ){$0 && $1 && $2 && $3 && !$4}
    }
    
    private func uploadImage(){
        APIManager.uploadImage(self.imageAvatar!.image!, self.userId.value) { url in
            print("Url upload: \(String(describing: url))")
            if let myUrl = url {
                let para = ["userId":self.userId.value, "pathAvatar":myUrl] as [String : Any]
                APIManager.requestData(url: "api/MyApi/UpdateAvatar", isLogin: true, method: .get, parameters: para, completion: { result in
                    switch result{
                    case .success(_, _):
                        self.uploadImageWallpaper()
                        break
                    case .failure(let error):
                        self.isRequest.accept(false)
                        self.error.accept("Error: \(error)")
                        print("Error update avatar: \(error)")
                        break
                    }
                })
            } else {
                self.isRequest.accept(false)
                self.error.accept("Error: Upload avatar faild")
            }
        }
    }
    
    private func uploadImageWallpaper(){
        APIManager.uploadImage(self.imageWallpaper!.image!,"wallpaper" + self.userId.value) { url in
            print("Url upload: \(String(describing: url))")
            if let myUrl = url {
                let para = ["userId":self.userId.value, "pathAvatar":myUrl] as [String : Any]
                APIManager.requestData(url: "api/MyApi/UpdateWallpaper", isLogin: true, method: .get, parameters: para, completion: { result in
                    switch result{
                    case .success(_, _):
                        self.updateInformation()
                        break
                    case .failure(let error):
                        self.isRequest.accept(false)
                        self.error.accept("Error: \(error)")
                        print("Error update wallpaper: \(error)")
                        break
                    }
                })
            } else {
                self.isRequest.accept(false)
                self.error.accept("Error: Upload wallpaper faild")
            }
        }
    }
    
    private func updateInformation(){
        let updateModel = InformationUSer(UserId: self.userId.value, FullName: self.name.value, Address: self.address.value, Phone: self.phone.value, DoB: self.birth.value)
        APIManager.requestData(url: "api/MyApi/UpdateInfomation", isLogin: true, method: .post, parameters: updateModel.toJson()) { (result) in
            switch result {
                case .success(_, _):
                    self.isRequest.accept(false)
                    self.isUpdateSuccess.accept(true)
                    break
                case .failure(let error):
                    self.isRequest.accept(false)
                    self.error.accept("Error: \(error)")
                    print("Update information user failded: \(error)")
                    break
            }
        }
    }
}
