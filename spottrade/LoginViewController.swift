//
//  LoginViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/26/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "colorPrimary")
        self.view.backgroundColor = UIColor(named: "colorPrimary")
        let button = UIButton(type: UIButtonType.system) as UIButton
        
        button.backgroundColor = UIColor.clear
        button.setTitle("Get Started", for: UIControlState.normal)
        button.tintColor = UIColor(named: "colorAccent")
        button.addTarget(self, action: #selector(LoginViewController.buttonAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        self.navigationController?.pushViewController(PhoneNumberViewController(), animated: true)
    }
}
