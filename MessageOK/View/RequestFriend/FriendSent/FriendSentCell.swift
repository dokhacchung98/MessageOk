//
//  FriendSentCell.swift
//  MessageOK
//
//  Created by Trung on 11/18/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class FriendSentCell: UICollectionViewCell {
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    var actionRep: ((String?, Bool)->Void)?
    var id: String?
    
    var FriendRequest:FriendRequest! {
        didSet{
            self.imgAvatar.loadImageFromUrl(urlString: FriendRequest._User?.Avatar ?? "")
            self.imgWallpaper.loadImageFromUrl(urlString: FriendRequest._User?.Wallpaper ?? "")
            self.txtName.text = FriendRequest._User?.FullName
            self.id = FriendRequest.Id
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgAvatar.makeRounded(width: 2, color: UIColor(rgb: 0xeaeaea).cgColor)
        // Initialization code
    }
    
    @IBAction func removeFR(_ sender: Any) {
        self.actionRep?(self.id!, false)
    }
    
    @IBAction func acceptFR(_ sender: Any) {
        self.actionRep?(self.id!, true)
    }
}
