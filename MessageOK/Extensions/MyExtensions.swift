//
//  MyExtenstions.swift
//  MessageOK
//
//  Created by Trung on 11/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit


/* Create View circle */
extension UIView {
    func makeRounded( width:CGFloat?, color:CGColor?) {
        self.layer.borderWidth = width ?? 1
        self.layer.masksToBounds = false
        self.layer.borderColor = color ?? UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

/* Convert hex to color */
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
