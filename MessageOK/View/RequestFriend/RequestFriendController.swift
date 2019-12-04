//
//  RequestFriendController.swift
//  MessageOK
//
//  Created by Trung on 11/5/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RequestFriendController: SwipViewController {
    
    var requestFriendViewModel:RequestFriendViewModel!
    @IBOutlet weak var viewUserList: UIView!
    @IBOutlet weak var viewBoundFR: UIView!
    @IBOutlet weak var viewFriendRequest: UIView!
    @IBOutlet weak var constrainHeightFR: NSLayoutConstraint!
    
    private lazy var userListTableViewController : UserListTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "UserListTableVC") as! UserListTableViewController
        self.add(asChildViewController: viewController, to: self.viewUserList)
        return viewController
    }()
    
    private lazy var friendSentController : FriendSentController = {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "FriendSentVC") as! FriendSentController
        self.add(asChildViewController: viewController, to: self.viewFriendRequest)
        return viewController
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Add Friend", image: UIImage(named: "addfriend"), tag: 3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestFriendViewModel = RequestFriendViewModel()
        _ = self.friendSentController.friendSentViewModel.listFR.bind{ value in
            if value.count <= 0{
                self.constrainHeightFR.constant = 0
            }else{
                self.constrainHeightFR.constant = 292
            }
        }
    }
}
