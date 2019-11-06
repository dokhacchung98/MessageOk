//
//  SplashScreenController.swift
//  MessageOK
//
//  Created by Trung on 11/4/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift

class SplashScreenController: UIViewController {

    var splashScreeenViewModel:SplashScreenViewModel!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashScreeenViewModel = SplashScreenViewModel()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            self.timer.invalidate()
            self.splashScreeenViewModel.isCountDownFinish.accept(true)
        })
        
        _ = self.splashScreeenViewModel.isLoadingFinish.asObservable().bind(onNext: { value in
            if value{
                switch self.splashScreeenViewModel.statusAccountLogin.value {
                case .login:
                    self.gotoLogin()
                    break
                case .addInforStart:
                    self.gotoAddInformationStart()
                    break
                case .home:
                    self.gotoHome()
                    break
                case .none:
                    break
                }
            }
        })
    }
    
    private func gotoHome(){
        self.dismiss(animated: true, completion: nil)
        MyTabBarControllerViewController.startPresent(uiViewController: self)
    }
    
    private func gotoLogin(){
        self.dismiss(animated: true, completion: nil)
        LoginController.startPresent(uiViewController: self)
    }
    
    private func gotoAddInformationStart(){
        self.dismiss(animated: true, completion: nil)
        InformationStartController.startPresent(uiViewController: self)
    }
}
