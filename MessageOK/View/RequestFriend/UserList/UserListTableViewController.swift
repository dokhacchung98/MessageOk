//
//  UserListTableViewController.swift
//  MessageOK
//
//  Created by Trung on 11/14/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserListTableViewController: UIViewController {
    
    var userListViewModel:UserListViewModel!
    let formatter = DateFormatter()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var myTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userListViewModel = UserListViewModel()

        self.bindingTableView()
    }
    
    private func bindingTableView(){
        let nib = UINib.init(nibName: "UserCell", bundle: nil)
        self.myTV.register(nib, forCellReuseIdentifier: "userCell")
        self.myTV.separatorStyle = UITableViewCell.SeparatorStyle.none

        _ = self.userListViewModel.listUser
            .bind(to: self.myTV.rx.items){
            (tableView: UITableView, index: Int, element: User) in
            
            guard let cell : UserTableViewCell = self.myTV.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell else {
                    print("Error get user cell")
                    fatalError()
                }
            let user = self.userListViewModel.listUser.value[index]
            cell.imgAvatar.loadImageFromUrl(urlString: user.Avatar ?? "")
            cell.txtName.text = user.FullName
            self.formatter.dateFormat = "dd-MMM-yyyy"
            cell.txtBirth.text = self.formatter.string(from: user.DoB ?? Date())
            cell.idUser = user.Id
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
    
            return cell
        }.disposed(by: disposeBag)
    }
}
