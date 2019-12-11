//
//  UserCell.swift
//  MessageOK
//
//  Created by Trung on 12/5/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class UserChatCell: UICollectionViewCell {
    @IBOutlet weak var txtContent: UILabel!
    @IBOutlet weak var viewBound: UIView!
    @IBOutlet weak var spacingR: NSLayoutConstraint!
    @IBOutlet weak var spacingL: NSLayoutConstraint!
    
    var MessageModel:MessageModel! {
        didSet{
            self.txtContent.text = MessageModel.ContentText!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        viewBound.layer.cornerRadius = 10
    }
}
