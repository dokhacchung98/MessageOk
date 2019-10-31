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
    @IBOutlet weak var txtEmail: CustomTextFieldICon!
    @IBOutlet weak var txtPassword: CustomTextFieldICon!
    @IBOutlet weak var btnLogin: UIButton!
    
    var loginViewModel: LoginViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModeView()
        
        self.loginViewModel.isValidInputLogin.bind{ valid in
            self.btnLogin.isEnabled = valid
            self.btnLogin.alpha = valid ? 1 : 0.5
        }.disposed(by: disposeBag)
    }
    
    private func setupModeView() {
        loginViewModel = LoginViewModel(tapLogin: self.btnLogin.rx.tap.asObservable())
        
        _ = txtEmail.rx.text.map{ $0 ?? "" }.bind(to: self.loginViewModel.loginUserInput)
        _ = txtPassword.rx.text.map{ $0 ?? ""}.bind(to: self.loginViewModel.loginPassInput)
    }
    
    private var loginObservable : Observable<Void>{
        return self.btnLogin.rx.tap.asObservable()
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
        
    }
}
