//
//  YourSpotsViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/26/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit

class YourSpotsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Spots"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(lbl)
        lbl.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lbl.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lbl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "Your Spizzles"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
