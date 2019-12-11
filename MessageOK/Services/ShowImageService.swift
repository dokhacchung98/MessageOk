//
//  ShowImageService.swift
//  MessageOK
//
//  Created by Trung on 12/10/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit

class ShowImageService {
    func show(path:String!) -> ShowImageController {
        let storyboard = UIStoryboard(name: "ShowImage", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "alertShowImage") as! ShowImageController
        alertVC.pathImage = path
        return alertVC
    }
}
