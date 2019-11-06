//
//  InformationStartController.swift
//  MessageOK
//
//  Created by Trung on 11/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InformationStartController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirth: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var viewBoundImage: UIView!
    @IBOutlet weak var viewBoundTop: UIView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    static func startPresent(uiViewController:UIViewController) {
        if let presentController = uiViewController.storyboard?.instantiateViewController(withIdentifier: "updateInformationStart") as? InformationStartController {
            uiViewController.present(presentController, animated: true, completion: nil)
        }
    }
    
    private let alertChooseDate = AlertChooseDateService()
    
    private let pickerImage = UIImagePickerController()
    
    private var informationViewModel : InformationStartViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBoundImage.makeRounded(width: 4, color: UIColor(rgb: 0xeaeaea).cgColor)
        self.viewBoundTop.layer.cornerRadius = 10
        self.btnUpdate.layer.cornerRadius = 5
        
        setupViewModel()
    }
    
    private func setupViewModel(){
        self.informationViewModel = InformationStartViewModel(imageView: self.imgThumbnail,
        buttonUpdate: self.btnUpdate.rx.tap.asObservable())
        
        _ = self.informationViewModel.isValid.bind{ valid in
            self.btnUpdate.alpha = valid ? 1 : 0.5
            self.btnUpdate.isEnabled = valid
        }
        
        _ = self.informationViewModel.isRequest.bind{ isRequest in
            self.btnUpdate.setTitle(isRequest ? "Please Wait..." : "Update", for: .normal)
        }
        
        _ = self.txtName.rx.text.map{ $0 ?? ""}.bind(to: self.informationViewModel.name)
        _ = self.txtPhone.rx.text.map{ $0 ?? ""}.bind(to: self.informationViewModel.phone)
        _ = self.txtAddress.rx.text.map{ $0 ?? ""}.bind(to: self.informationViewModel.address)
        _ = self.informationViewModel.birth.map{ date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let myString = formatter.string(from: date)
                let yourDate = formatter.date(from: myString)
                formatter.dateFormat = "dd-MMM-yyyy"
                let myStringafd = formatter.string(from: yourDate!)
                return myStringafd
            }.bind(to: self.txtBirth.rx.text)
        
        _ = self.informationViewModel.isUpdateSuccess.asObservable().bind{ isSuccess in
            if isSuccess {
                self.gotoHome()
            }
        }
   }
    
    @IBAction func chooseDate(_ sender: Any) {
        let alertVC = alertChooseDate.alert(){ date in
            self.informationViewModel.birth.accept(date)
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func actionPickImage(_ sender: Any) {
        pickerImage.delegate = self
        pickerImage.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        present(pickerImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgThumbnail.image = image
            self.informationViewModel.changeAvatar = true
        } else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func gotoHome(){
        self.dismiss(animated: true, completion: nil)
        MyTabBarControllerViewController.startPresent(uiViewController: self)
    }
}
