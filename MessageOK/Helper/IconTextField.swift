//
//  IconTextField.swift
//  MessageOK
//
//  Created by Trung on 10/25/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextFieldICon: UITextField{
    private var _iconColor: UIColor = UIColor.lightGray
    private var _iconName: String?
    
    @IBInspectable
    var iconColor : UIColor {
        get{
            return _iconColor
        }
        set(value){
            _iconColor = value
            self.tintColor = _iconColor
        }
    }
    
    @IBInspectable
    var iconName: String?{
        get{
            return _iconName
        }
        set(value){
            _iconName = value
            self.setIcon(UIImage(named: _iconName!)!)
        }
    }
}
