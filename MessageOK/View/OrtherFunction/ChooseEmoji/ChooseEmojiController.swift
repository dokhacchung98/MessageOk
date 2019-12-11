//
//  ChooseEmojiController.swift
//  MessageOK
//
//  Created by Trung on 12/11/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChooseEmojiController: UIViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    @IBOutlet weak var txtEmoji: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var type = 0
    var viewModel:ChooseEmojiViewModel!
    var chooseAction: ((String)->Void)?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = ChooseEmojiViewModel()
        self.setupView()
    }
    
    @IBAction func backEmoji(_ sender: Any) {
        if (type == 0) {
            self.dismiss(animated: true, completion: nil)
        } else {
            type = 0
            self.viewModel.getTypeShow()
        }
    }
    
    func setupView() {
        self.collectionView.delegate = self
        
        self.collectionView.register(UINib(nibName: "ChooseEmojiCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ChooseEmojiCell.self))

        _ = self.viewModel.listShow.bind(to: self.collectionView.rx.items(cellIdentifier: "ChooseEmojiCell", cellType: ChooseEmojiCell.self)){ (row, item, cell) in
            cell.pathImage = item.Path ?? ""
            }.disposed(by: disposeBag)
        
        _ = self.collectionView.rx.itemSelected.asObservable().subscribe(onNext: { (IndexPath) in
            let item = self.viewModel.listShow.value[IndexPath.row]
            if self.type == 0 {
                self.type = 1
                self.viewModel.getEmojiShow(id: item.Id!)
            } else {
                self.chooseAction?(item.Path!)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size
        let myW = Int(size.width / 3) - 30
        return CGSize(width: myW, height: 100)
    }
}
