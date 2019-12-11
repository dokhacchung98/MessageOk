//
//  ShowEmojiAlert.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit

class ShowEmojiAlert{
    func alert(competion: @escaping (String)-> Void) -> ChooseEmojiController {
        let storyBoard = UIStoryboard(name: "ChooseEmoji", bundle: .main)
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "ChooseEmoji") as! ChooseEmojiController
        alertVC.chooseAction = competion
        return alertVC
    }
}
