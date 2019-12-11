//
//  ChatController.swift
//  MessageOK
//
//  Created by Trung on 12/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatController: UIViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var collectionMessage: UICollectionView!
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnEmoji: UIButton!
    private var alertImage:ShowImageService!
    private var alertEmoji:ShowEmojiAlert!

    private let pickerImage = UIImagePickerController()
    
    var chatViewModel:ChatViewModel!
    var currentUser:User?
    var disposeBag = DisposeBag()
    
    var isScroll = true

    static func startPresent(uiViewController:UIViewController) {
        if let presentController = uiViewController.storyboard?.instantiateViewController(withIdentifier: "chatscreen") as? ChatController {
            uiViewController.show(presentController, sender: nil)
        }
    }
    
    var idFriend: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionMessage.delegate = self
        if (idFriend == nil) {
            self.dismiss(animated: true, completion: nil)
        }
        self.alertImage = ShowImageService()
        self.alertEmoji = ShowEmojiAlert()

        let origImage = UIImage(named: "image")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.btnImage.setImage(tintedImage, for: .normal)
        self.btnImage.tintColor = UIColor(rgb: 0xf46b21)
        
        let origImage1 = UIImage(named: "emoji")
        let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
        self.btnEmoji.setImage(tintedImage1, for: .normal)
        self.btnEmoji.tintColor = UIColor(rgb: 0xf46b21)
        
        let origImage2 = UIImage(named: "send")
        let tintedImage2 = origImage2?.withRenderingMode(.alwaysTemplate)
        self.btnSend.setImage(tintedImage2, for: .normal)
        self.btnSend.imageView!.contentMode = .scaleToFill
        self.btnSend.tintColor = UIColor(rgb: 0xf46b21)
        
        chatViewModel = ChatViewModel(idRoom: idFriend!)
        self.setupComponent()
    }
    
    func setupComponent() {
        self.imgAvatar.makeRounded(width: 2, color: UIColor(rgb: 0xeaeaea).cgColor)
        self.collectionMessage.register(UINib(nibName: "UserChatCell", bundle: nil), forCellWithReuseIdentifier: String(describing: UserChatCell.self))
        
        self.collectionMessage.register(UINib(nibName: "FriendChatCell", bundle: nil), forCellWithReuseIdentifier: String(describing: FriendChatCell.self))

        self.collectionMessage.register(UINib(nibName: "ChatImageFriendCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ChatImageFriendCell.self))

        self.collectionMessage.register(UINib(nibName: "ChatImageUserCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ChatImageUserCell.self))

        collectionMessage.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        _ = self.chatViewModel.pathImage.asObservable().bind(onNext: { (path) in
            self.imgAvatar.loadImageFromUrl(urlString: path)
        }).disposed(by: disposeBag)
        
        _ = self.chatViewModel.nickName.asObservable().bind(onNext: { (nickName) in
            self.txtName.text = nickName
        }).disposed(by: disposeBag)
        
        _ = self.chatViewModel.listMessage.bind { _ in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatViewModel.listMessage.value.count-1, section: 0)
                self.collectionMessage.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        _ = self.chatViewModel.listMessage.asDriver().drive(self.collectionMessage.rx.items){ [weak self] collectionView, index, item in
            let indexPath = IndexPath(row: index, section: 0)
            
            if item.UserId! == self!.chatViewModel.idUser! {
                if item.MessType == .Image || item.MessType == .Icon {
                    let cell = self?.collectionMessage.dequeueReusableCell(withReuseIdentifier: "ChatImageUserCell", for: indexPath) as! ChatImageUserCell
                    cell.MessageModel = item
                    return cell
                } else {
                    let cell = self?.collectionMessage.dequeueReusableCell(withReuseIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
                    cell.MessageModel = item
                    return cell
                }
            } else {
                if item.MessType == .Image || item.MessType == .Icon {
                    let cell = self?.collectionMessage.dequeueReusableCell(withReuseIdentifier: "ChatImageFriendCell", for: indexPath) as! ChatImageFriendCell
                    cell.MessageModel = item
                    return cell
                } else {
                    let cell = self?.collectionMessage.dequeueReusableCell(withReuseIdentifier: "FriendChatCell", for: indexPath) as! FriendChatCell
                    cell.MessageModel = item
                    return cell
                }
            }
        }.disposed(by: disposeBag)
        
        
        
        self.collectionMessage.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            let item = self.chatViewModel.listMessage.value[indexPath.row]
            if item.MessType == .Image {
                self.showImageAlert(path: item.PathImage ?? "")
            }
        }).disposed(by: disposeBag)
        
        _ = self.txtContent.rx.text.bind(onNext: { (value) in
            if let mess = value {
                if mess.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    self.btnSend.isEnabled = true
                    self.btnSend.alpha = 1
                } else {
                    self.btnSend.isEnabled = false
                    self.btnSend.alpha = 0.7
                }
            }
        })
        
        _ = self.btnSend.rx.tap.asObservable().bind(onNext: { _ in
            if let mess = self.txtContent.text {
                if mess != "" {
                    self.chatViewModel.createMess(Content: mess, EmojiId: nil, PathImage: nil, PathVideo: nil)
                    self.txtContent.text = ""
                }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myMess = self.chatViewModel.listMessage.value[indexPath.row]
        
        if myMess.MessType == .Text {
            let size = CGSize(width: (view.frame.width - 91), height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: myMess.ContentText ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        } else if myMess.MessType == .Image {
            return CGSize(width: view.frame.width, height: 150)
        } else if myMess.MessType == .Icon {
            return CGSize(width: view.frame.width, height: 100)
        }
        return CGSize(width: 100, height: 100)
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendImage(_ sender: Any) {
        pickerImage.delegate = self
        pickerImage.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        present(pickerImage, animated: true, completion: nil)
    }
    
    @IBAction func openEmoji(_ sender: Any) {
        let alertVC = self.alertEmoji.alert { (value) in
            self.chatViewModel.sendEmojiMessage(path: value)
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           self.chatViewModel.sendImageMessage(image: image)
        } else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func showImageAlert(path: String!) {
        let alertVC = alertImage.show(path: path)
        self.present(alertVC, animated: true, completion: nil)
    }
}
