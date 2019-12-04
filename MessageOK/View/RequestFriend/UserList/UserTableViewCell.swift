//
//  UserTableViewCell.swift
//  MessageOK
//
//  Created by Trung on 11/14/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtBirth: UILabel!
    @IBOutlet weak var btnSendFR: UIButton!
    
    var idUser:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sendFriendRequest(_ sender: Any) {
        if self.idUser != nil {
            print("Send Friend To: \(String(describing: self.idUser))")
            self.btnSendFR.isEnabled = false
            self.btnSendFR.alpha = 0.5
            self.btnSendFR.titleLabel?.text = "Sending..."
            let parameter:[String:Any] = ["IdUser":idUser!]
            APIManager.requestData(url: "api/MyApi/SendFriendRequest", isLogin: true, method: .post, parameters: parameter){ result in
                self.btnSendFR.titleLabel?.text = "Add Friend"
                switch result {
                case .success(_, _):
                    break
                case .failure(_):
                    self.btnSendFR.isEnabled = true
                    self.btnSendFR.alpha = 1
                    break
                }
            }
        }
    }
}
