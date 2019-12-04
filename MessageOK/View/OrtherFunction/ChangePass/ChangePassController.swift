//
//  ChangePassController.swift
//  MessageOK
//
//  Created by Trung on 11/12/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChangePassController: UITabBarController, UITextFieldDelegate {
    @IBOutlet weak var viewBound: UIView!
    @IBOutlet weak var txtOld: UITextField!
    @IBOutlet weak var txtNew: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var txtError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePass(_ sender: Any) {
        self.btnChange.isEnabled = false
        self.btnChange.alpha = 0.5
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidChange() {
        let old = self.txtOld.text ?? ""
        let pass = self.txtNew.text ?? ""
        let confirm = self.txtConfirm.text ?? ""
        
        if(old.count > 5 && pass.count > 5 && confirm.count > 5) {
            self.btnChange.isEnabled = true
            self.btnChange.alpha = 1
        }
    }
    
    private func request(){
        let old = self.txtOld.text ?? ""
        let pass = self.txtNew.text ?? ""
        let confirm = self.txtConfirm.text ?? ""
        var para: [String:Any] = [:]
        para["OldPassword"] = old
        para["NewPassword"] = pass
        para["ConfirmPassword"] = confirm
        APIManager.requestData(url: "api/Account/ChangePassword", isLogin: true, method: .post, parameters: para, completion: { result in
            switch result {
            case .success(_, _):
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(let err):
                self.txtError.text = err.localizedDescription
                break
            }
        })
    }
}
