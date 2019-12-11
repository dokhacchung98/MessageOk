//
//  ChatImageFriendCell.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChatImageFriendCell: UICollectionViewCell {
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    var MessageModel:MessageModel! {
        didSet{
            if MessageModel.MessType == .Image {
                self.imgThumbnail.loadImageFromUrl(urlString: MessageModel.PathImage ?? "")
                self.imgThumbnail.layer.borderWidth = 2
                self.imgThumbnail.layer.masksToBounds = false
                self.imgThumbnail.layer.borderColor = UIColor(rgb: 0xf46b21).cgColor
            } else if MessageModel.MessType == .Icon {
                self.imgThumbnail.loadImageFromUrl(urlString: MessageModel.EmojiId ?? "")
                self.imgThumbnail.contentMode = .scaleToFill
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgThumbnail.layer.cornerRadius = 10
    }
}
