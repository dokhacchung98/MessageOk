//
//  ChatFriendCell.swift
//  MessageOK
//
//  Created by Trung on 11/19/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChatFriendCell: UITableViewCell {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtMes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0;//Choose your custom row height
    }
}
