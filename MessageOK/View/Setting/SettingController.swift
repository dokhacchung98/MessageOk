//
//  SettingController.swift
//  MessageOK
//
//  Created by Trung on 11/5/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class SettingController: SwipViewController {
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtDoB: UILabel!
    @IBOutlet weak var txtPhone: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    
    let myUserDefault = MyUserDefault.instance
    var idUser:String?
    var settingViewModel:SettingViewModel!
    var changePassService = ChangePassService()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting"), tag: 4)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgAvatar.makeRounded(width: 4, color: UIColor(rgb: 0xeaeaea).cgColor)
        self.imgWallpaper.layer.cornerRadius = 10
        self.loadDataFromLocal()
        self.settingViewModel = SettingViewModel()
        
        _ = settingViewModel.isLogoutSuccess.asObservable().bind{ result in
            if result {
                self.myUserDefault.removeObject(key: .Token)
                self.myUserDefault.removeObject(key: .Avatar)
                self.myUserDefault.removeObject(key: .BoB)
                self.myUserDefault.removeObject(key: .Email)
                self.myUserDefault.removeObject(key: .FullName)
                self.myUserDefault.removeObject(key: .Phone)
                self.myUserDefault.removeObject(key: .UserId)
                self.myUserDefault.removeObject(key: .UserName)
                self.myUserDefault.removeObject(key: .Wallpaper)
                LoginController.startPresent(uiViewController: self)
            }
        }
    }
    
    private func loadDataFromLocal(){
        if let fullName = self.myUserDefault.getObject(key: .FullName) {
            self.txtName.text = (fullName as! String)
        }
        if let email = self.myUserDefault.getObject(key: .Email) {
            self.txtEmail.text = (email as! String)
        }
        if let phone = self.myUserDefault.getObject(key: .Phone) {
            self.txtPhone.text = (phone as! String)
        }
        if let address = self.myUserDefault.getObject(key: .Address) {
            self.txtAddress.text = (address as! String)
        }
        if let dob = self.myUserDefault.getObject(key: .BoB) {
            self.txtDoB.text = (dob as! String)
        }
        if let avatar = self.myUserDefault.getObject(key: .Avatar) {
            self.imgAvatar.loadImageFromUrl(urlString: avatar as! String)
        }
        if let wall = self.myUserDefault.getObject(key: .Wallpaper) {
            self.imgWallpaper.loadImageFromUrl(urlString: wall as! String)
        }
        
    }
    
    private func loadDataOnline(){
        
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        let alert = UIAlertController(title: "Alert?", message: "Do you want to logout.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func showFormChange(_ sender: Any) {
        let alertVC = self.changePassService.alert()
        self.tabBarController!.present(alertVC, animated: true, completion: nil)
//        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func gotoChangeInformation(_ sender: Any) {
    }
    
    private func logout(){
        self.settingViewModel.logoutAccount()
    }
}
