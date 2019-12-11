//
//  ShowImageController.swift
//  MessageOK
//
//  Created by Trung on 12/10/19.
//  Copyright © 2019 Trung. All rights reserved.
//

import UIKit

class ShowImageController: UIViewController {
    @IBOutlet weak var imgThum: UIImageView!
    var pathImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgThum.loadImageFromUrl(urlString: pathImage)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
