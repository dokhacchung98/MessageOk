//
//  ChooseDateController.swift
//  MessageOK
//
//  Created by Trung on 11/3/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ChooseDateController: UIViewController {
    @IBOutlet weak var viewBournd: UIView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    var chooseAction: ((Date)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBournd.layer.cornerRadius = 8
        self.btnChoose.layer.cornerRadius = 8
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("Choose Date: \(self.pickerDate.date)")
        self.chooseAction?(self.pickerDate.date)
    }
}
