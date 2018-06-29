//
//  HistoryViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/26/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"

        self.view.backgroundColor = UIColor.white
        
        getHistory(type: "all")
    }
    
    private func getHistory(type : String){
        Alamofire.request("http://192.168.1.153:3000/location/history?sellerID=" + UserDefaults.standard.string(forKey: "logged_in_user_id")! + "type=" + type).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json =  JSON(value)
                    
                    if json["status"] == "success" {
                        print(json["location"])
                    } else {
                        print(json["reason"])
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
