//
//  ChooseEmojiCell.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChooseEmojiCell: UICollectionViewCell {
    @IBOutlet weak var myImg:UIImageView!
    
    var pathImage:String! {
        didSet{
            self.myImg.loadImageFromUrl(urlString: pathImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myImg.layer.borderWidth = 1
        myImg.layer.borderColor = UIColor.orange.cgColor
    }
}
