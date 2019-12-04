//
//  ChangePassService.swift
//  MessageOK
//
//  Created by Trung on 11/12/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit

class ChangePassService{
    func alert() -> ChangePassController {
        let storyBoard = UIStoryboard(name: "ChangePass", bundle: .main)
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "alertChangePass") as! ChangePassController
        return alertVC
    }
}
