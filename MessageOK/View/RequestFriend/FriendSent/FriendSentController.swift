//
//  FriendSentController.swift
//  MessageOK
//
//  Created by Trung on 11/18/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FriendSentController: UIViewController {
    
    @IBOutlet private weak var albumsCollectionView: UICollectionView!
    var friendSentViewModel:FriendSentViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.friendSentViewModel = FriendSentViewModel()
        
        setupBinding()
    }
    
    func setupBinding() {
        albumsCollectionView.register(UINib(nibName: "FriendSentCell", bundle: nil), forCellWithReuseIdentifier: String(describing: FriendSentCell.self))
        
        let width = view.frame.size.width
        let layout = albumsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 240)
        
        _ = self.friendSentViewModel.listFR.bind(to: self.albumsCollectionView.rx.items(cellIdentifier: "FriendSentCell", cellType: FriendSentCell.self)){ (row, fr, cell) in
            cell.FriendRequest = fr
            cell.actionRep = { (id, isAccept) in
                self.friendSentViewModel.repFriendRequest(id: id!, isAccept: isAccept)
            }
            
        }.disposed(by: disposeBag)
        
        albumsCollectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0

                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
                
            })).disposed(by: disposeBag)
    }
}
