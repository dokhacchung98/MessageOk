//
//  LoginController.swift
//  MessageOK
//
//  Created by Trung on 10/20/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginController: UIViewController {
    
    static func startPresent(uiViewController:UIViewController) {
        if let presentController = uiViewController.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginController {
            uiViewController.present(presentController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var txtEmail: CustomTextFieldICon!
    @IBOutlet weak var txtPassword: CustomTextFieldICon!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var constrainRegister: NSLayoutConstraint!
    @IBOutlet weak var formRegister: UIView!
    @IBOutlet weak var txtError: UILabel!
    
    @IBOutlet weak var txtEmailRegister: CustomTextFieldICon!
    @IBOutlet weak var txtPassRegister: CustomTextFieldICon!
    @IBOutlet weak var txtPassRegisterConfirm: CustomTextFieldICon!
    @IBOutlet weak var btnRequestRegister: UIButton!
    
    var loginViewModel: LoginViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModeView()
        
        self.loginViewModel.isValidInputLogin.bind{ valid in
            self.btnLogin.isEnabled = valid
            self.btnLogin.alpha = valid ? 1 : 0.5
        }.disposed(by: disposeBag)
        
        self.loginViewModel.isValidInputRegister.bind{valid in
            self.btnRequestRegister.isEnabled = valid
            self.btnRequestRegister.alpha = valid ? 1 : 0.5
        }.disposed(by: disposeBag)
    }
    
    private func setupModeView() {
        btnLogin.layer.cornerRadius = 5
        btnSignUp.layer.cornerRadius = 5
        self.constrainRegister.constant = self.view.frame.height
        self.formRegister.layer.cornerRadius = 10
        
        loginViewModel = LoginViewModel(tapLogin: self.btnLogin.rx.tap.asObservable(), tapRegister: self.btnRequestRegister.rx.tap.asObservable())
        
        _ = self.loginViewModel.isLoginSuccessful.bind{ isSuccess in
            if(isSuccess){
                
            }
        }
        _ = self.loginViewModel.isRegisterSuccessful.bind{ isSuccess in
            if(isSuccess){
                print("Register success")
                self.showOrHiden(false)
                self.txtEmail.text = self.loginViewModel.regisEmailInput.value
                self.txtPassword.text = self.loginViewModel.regisPassInput.value
            }
        }
        
        _ = self.loginViewModel.messageError.asObservable().bind{value in
            self.txtError.text = value
        }.disposed(by: disposeBag)
        
        _ = txtEmailRegister.rx.text.map{ $0 ?? ""}.bind(to:
            self.loginViewModel.regisEmailInput)
        _ = txtPassRegister.rx.text.map{ $0 ?? ""}.bind(to:
            self.loginViewModel.regisPassInput)
        _ = txtPassRegisterConfirm.rx.text.map{ $0 ?? ""}.bind(to:
            self.loginViewModel.regisPassConfirmInput)
        _ = txtEmail.rx.text.map{ $0 ?? "" }.bind(to: self.loginViewModel.loginUserInput)
        _ = txtPassword.rx.text.map{ $0 ?? ""}.bind(to: self.loginViewModel.loginPassInput)
        _ = self.loginViewModel.isLoading.bind { result in
            if(result){
                self.btnLogin.setTitle("Please Wait...", for: .normal)
                self.btnRequestRegister.setTitle("Please Wait...", for: .normal)
            }else{
                self.btnLogin.setTitle("Login", for: .normal)
                self.btnRequestRegister.setTitle("Register", for: .normal)
            }
        }.disposed(by: disposeBag)
    }
    @IBAction func showFormRegister(_ sender: Any) {
        showOrHiden(true)
    }
    
    @IBAction func hidenFormRegister(_ sender: Any) {
        showOrHiden(false)
    }
    
    private var loginObservable : Observable<Void>{
        return self.btnLogin.rx.tap.asObservable()
    }
    
    private func showOrHiden(_ isShow: Bool){
        if isShow {
            self.constrainRegister.constant = 280
        }else{
            self.constrainRegister.constant = self.view.frame.height
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func btnForgotPass(_ sender: Any) {
        
    }
}
