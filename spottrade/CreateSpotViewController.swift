//
//  CreateSpotViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/28/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateSpotViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Spot"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "done_black"), style: .plain, target: self, action: #selector(createSpot))
    }
    
    @objc func createSpot() {
        
    }
}
