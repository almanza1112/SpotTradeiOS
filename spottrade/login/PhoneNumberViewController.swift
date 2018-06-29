//
//  PhoneNumberViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/26/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Phone Number"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "done_black"), style: .plain, target: self, action: #selector(authPhoneNumber))
    }
    
    @objc func authPhoneNumber(){
        
    }
}
