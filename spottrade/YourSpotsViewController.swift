//
//  YourSpotsViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/26/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class YourSpotsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Spots"
        self.view.backgroundColor = UIColor.white
        
        getYourSpots(type: "all")
        
        /*
        self.view.addSubview(lbl)
        lbl.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lbl.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lbl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
 */
    }
    
    private func getYourSpots(type : String){
        Alamofire.request("http://192.168.1.153:3000/location/yourspots?id=" + UserDefaults.standard.string(forKey: "logged_in_user_id")! + "&transaction=available&type=" + type).responseJSON { response in
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
    
    /*
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "Your Spizzles"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }() */
}
