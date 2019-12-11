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

class UpdateInformationViewModel {
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
    var changeAvatar = false
    var changeWall = false
    
    var buttonUpdate:Observable<Void>
    
    init(imageView:UIImageView, imageWallView:UIImageView, buttonUpdate: Observable<Void>) {
        self.imageAvatar = imageView
        self.imageWallpaper = imageWallView
        self.buttonUpdate = buttonUpdate
        
        let userId = MyUserDefault.instance.getObject(key: .UserId) as? String ?? ""
        self.userId.accept(userId)
        
        _ = self.buttonUpdate.bind{ _ in
            self.isRequest.accept(true)
            if self.changeAvatar {
                self.uploadImage()
            } else if self.changeWall {
                self.uploadImageWallpaper()
            } else {
                self.updateInformation()
            }
        }
        self.getData()
    }
    
    func getData() {
        name.accept(MyUserDefault.instance.getObject(key: .FullName) as? String ?? "")
        let s = MyUserDefault.instance.getObject(key: .BoB) as? String ?? "01/01/1970"
        let d = getDate(t: s)
        birth.accept(d ?? Date())
        phone.accept(MyUserDefault.instance.getObject(key: .Phone) as? String ?? "")
        address.accept(MyUserDefault.instance.getObject(key: .Address) as? String ?? "")
        let av = MyUserDefault.instance.getObject(key: .Avatar) as? String ?? "https://firebasestorage.googleapis.com/v0/b/luu-data.appspot.com/o/default_user.png?alt=media&token=7fc1e7dd-202b-4057-88eb-981c15f8e9c5"
        self.imageAvatar?.loadImageFromUrl(urlString: av)
        let wa = MyUserDefault.instance.getObject(key: .Wallpaper) as? String ?? "https://firebasestorage.googleapis.com/v0/b/luu-data.appspot.com/o/wall_default.jpg?alt=media&token=ec7a33a5-b9cf-4411-87c2-a7512529da42"
        self.imageWallpaper?.loadImageFromUrl(urlString: wa)
    }
    
    func getDate(t:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: t)
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
            if let myUrl = url {
                let para = ["userId":self.userId.value, "pathAvatar":myUrl] as [String : Any]
                APIManager.requestData(url: "api/MyApi/UpdateAvatar", isLogin: true, method: .get, parameters: para, completion: { result in
                    switch result{
                    case .success(_, _):
                        if self.changeWall {
                            self.uploadImageWallpaper()
                        } else {
                            self.updateInformation()
                        }
                        break
                    case .failure(let error):
                        self.isRequest.accept(false)
                        self.error.accept("Error: \(error)")
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
                self.checkInformationUserIsEmpty()
                break
            case .failure(let error):
                self.isRequest.accept(false)
                self.error.accept("Error: \(error)")
                break
            }
        }
    }
    
    private func checkInformationUserIsEmpty(){
        let myUserDefault = MyUserDefault.instance
        APIManager.requestData(url: "api/MyApi/GetUserLogin", isLogin: true, method: .get, parameters: nil) { result in
            switch result{
            case .success(_, let body):
                myUserDefault.saveObject(value: body!["Email"].rawValue, key: .Email)
                myUserDefault.saveObject(value: body!["Avatar"].rawValue, key: .Avatar)
                myUserDefault.saveObject(value: body!["FullName"].rawValue, key: .FullName)
                myUserDefault.saveObject(value: body!["DoB"].rawValue, key: .BoB)
                myUserDefault.saveObject(value: body!["Address"].rawValue, key: .Address)
                myUserDefault.saveObject(value: body?["Wallpaper"].rawValue ?? "", key: .Wallpaper)
                myUserDefault.saveObject(value: body!["Phone"].rawValue, key: .Phone)
                self.isRequest.accept(false)
                self.isUpdateSuccess.accept(true)
                break
            case .failure(let error as NSError):
                self.isRequest.accept(false)
                self.error.accept("Error: \(error)")
                break
            }
        }
    }
}
