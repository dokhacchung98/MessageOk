//
//  Extensions.swift
//  MessageOK
//
//  Created by Trung on 10/25/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import RxSwift
import RxCocoa

extension UITextField{
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
        let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }
}

extension UIViewController {
    func setOnline() -> BehaviorRelay<Bool> {
        let mystatus = BehaviorRelay<Bool>(value: false)
        let idUser = MyUserDefault.instance.getObject(key: .UserId) as? String ?? ""
        if idUser != "" {
            _ = Database.database().reference().child("ONLINE").child(idUser).observe(.childChanged) { snap in
                let value = snap.value as? NSDictionary
                let status = value?["Status"] as? Int ?? 0
                if ((Int(NSDate().timeIntervalSince1970) - status) < 300000) {
                    mystatus.accept(true)
                } else {
                    mystatus.accept(false)
                }
            }
        }
        return mystatus
    }
}

extension UICollectionView {
    func myScrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}
