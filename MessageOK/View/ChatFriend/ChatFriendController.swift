//
//  ChatFriendController.swift
//  MessageOK
//
//  Created by Trung on 11/5/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatFriendController: SwipViewController {
    
    var chatFriendViewModel: ChatFriendViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var myTV: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "home"), tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatFriendViewModel = ChatFriendViewModel()

        self.bindingTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.chatFriendViewModel.loadUserJoinRoom()
    }
    
    private func bindingTableView() {
        let nib = UINib.init(nibName: "ChatFriend", bundle: nil)
        self.myTV.register(nib, forCellReuseIdentifier: "ChatFriendCell")
        self.myTV.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        _ = self.chatFriendViewModel.listUserJoinRoom
            .bind(to: self.myTV.rx.items) {
                (tableView: UITableView, index: Int, element: UserJoinRoom) in
                
                guard let cell : ChatFriendCell = self.myTV.dequeueReusableCell(withIdentifier: "ChatFriendCell") as? ChatFriendCell else {
                    print("Error get user cell")
                    fatalError()
                }
                let userJoinRoom = self.chatFriendViewModel.listUserJoinRoom.value[index]
                cell.txtName.text = userJoinRoom.NickName
                cell.txtMes.text = "lasst messs"
                cell.imgAvatar.loadImageFromUrl(urlString: userJoinRoom._User.Avatar!)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            }.disposed(by: disposeBag)

        self.myTV.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            let currentUJR = self.chatFriendViewModel.listUserJoinRoom.value[indexPath.row]
            self.performSegue(withIdentifier: "present_chat", sender: currentUJR)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "present_chat") {
            let vc = segue.destination as! ChatController
            vc.idFriend = (sender as! UserJoinRoom).RoomId!
        }
    }
}
