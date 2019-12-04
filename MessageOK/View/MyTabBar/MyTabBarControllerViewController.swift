//
//  MyTabBarControllerViewController.swift
//  MessageOK
//
//  Created by Trung on 11/6/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class MyTabBarControllerViewController: UITabBarController {
    
    static func startPresent(uiViewController:UIViewController) {
        if let presentController = uiViewController.storyboard?.instantiateViewController(withIdentifier: "tabbarscreen") as? MyTabBarControllerViewController {
            uiViewController.show(presentController, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
