//
//  AlertChooseDateService.swift
//  MessageOK
//
//  Created by Trung on 11/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit

class AlertChooseDateService{
    func alert(competion: @escaping (Date)-> Void) -> ChooseDateController {
        let storyBoard = UIStoryboard(name: "ChooseDate", bundle: .main)
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "alertChooseDate") as! ChooseDateController
        alertVC.chooseAction = competion
        return alertVC
    }
}
