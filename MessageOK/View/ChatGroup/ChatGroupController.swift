//
//  ChatGroupController.swift
//  MessageOK
//
//  Created by Trung on 11/5/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChatGroupController: SwipViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Groups", image: UIImage(named: "group"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
