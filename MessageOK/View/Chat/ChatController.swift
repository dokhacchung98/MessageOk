//
//  ChatController.swift
//  MessageOK
//
//  Created by Trung on 12/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    
    var currentUser:User?
    
    static func startPresent(uiViewController:UIViewController) {
        if let presentController = uiViewController.storyboard?.instantiateViewController(withIdentifier: "chatscreen") as? ChatController {
            uiViewController.show(presentController, sender: nil)
        }
    }
    
    var idFriend: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (idFriend == nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        print("Id user: \(String(describing: idFriend))")

        // Do any additional setup after loading the view.
    }
    
    func setupComponent() {
        
    }
}
