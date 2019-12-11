//
//  UpdateInformationController.swift
//  MessageOK
//
//  Created by Trung on 12/9/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UpdateInformationController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirth: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var imgWallPaper: UIImageView!
    @IBOutlet weak var viewBoundImage: UIView!
    @IBOutlet weak var viewBoundTop: UIView!
    @IBOutlet weak var btnUpdate: UIButton!
    var pickAvatar = false
    var pickWallPaper = false
    
    private let alertChooseDate = AlertChooseDateService()
    
    private let pickerImage = UIImagePickerController()
    
    var viewModel: UpdateInformationViewModel!
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBoundImage.makeRounded(width: 4, color: UIColor(rgb: 0xeaeaea).cgColor)
        self.viewBoundTop.layer.cornerRadius = 10
        self.btnUpdate.layer.cornerRadius = 5

        self.setupViewModel()
    }
    
    private func setupViewModel(){
        self.viewModel = UpdateInformationViewModel(imageView: self.imgThumbnail, imageWallView: self.imgWallPaper, buttonUpdate: self.btnUpdate.rx.tap.asObservable())
        
        _ = self.viewModel.isValid.bind{ valid in
            self.btnUpdate.alpha = valid ? 1 : 0.5
            self.btnUpdate.isEnabled = valid
        }
        
        _ = self.viewModel.isRequest.bind{ isRequest in
            self.btnUpdate.setTitle(isRequest ? "Please Wait..." : "Update", for: .normal)
        }
        
        _ = self.viewModel.address.bind(to: self.txtAddress.rx.text)
        _ = self.viewModel.name.bind(to: self.txtName.rx.text)
        _ = self.viewModel.phone.bind(to: self.txtPhone.rx.text)
        
        _ = self.txtName.rx.text.map{ $0 ?? ""}.bind(to: self.viewModel.name)
        _ = self.txtPhone.rx.text.map{ $0 ?? ""}.bind(to: self.viewModel.phone)
        _ = self.txtAddress.rx.text.map{ $0 ?? ""}.bind(to: self.viewModel.address)
        _ = self.viewModel.birth.map{ date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: date)
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "dd-MMM-yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            return myStringafd
            }.bind(to: self.txtBirth.rx.text)
        
        _ = self.viewModel.isUpdateSuccess.asObservable().bind{ isSuccess in
            if isSuccess {
                self.gotoHome()
            }
        }
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        let alertVC = alertChooseDate.alert(){ date in
            self.viewModel.birth.accept(date)
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func actionPickImage(_ sender: Any) {
        pickAvatar = true
        pickerImage.delegate = self
        pickerImage.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        present(pickerImage, animated: true, completion: nil)
    }
    
    @IBAction func pickWallPaper(_ sender: Any) {
        pickWallPaper = true
        pickerImage.delegate = self
        pickerImage.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        present(pickerImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if( pickAvatar){
                imgThumbnail.image = image
                self.viewModel.changeAvatar = true
            } else {
                imgWallPaper.image = image
                self.viewModel.changeWall = true
            }
            pickAvatar = false
            pickWallPaper = false
        } else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func gotoHome(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitScreen(_ sender: Any) {
        self.gotoHome()
    }
}
