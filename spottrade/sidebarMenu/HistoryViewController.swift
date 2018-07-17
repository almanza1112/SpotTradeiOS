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

    var filterTypeSelected = "all"
    var filterCategorySelected = "all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"

        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "done_black"), style: .plain, target: self, action: #selector(filterHistory))
        
        getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
    }
    
    private func getHistory(type : String, category: String){
        Alamofire.request("http://192.168.1.153:3000/location/history?sellerID=" + UserDefaults.standard.string(forKey: "logged_in_user_id")! + "&type=" + type + "&category=" + category).responseJSON { response in
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
    
    @objc func filterHistory(){
        let alert = UIAlertController(title: "Filter History", message: nil, preferredStyle: .alert)
        let type = UIAlertAction(title: "Type", style: .default) { (action) in
            self.filterType()
        }
        let category = UIAlertAction(title: "Category", style: .default) { (action) in
            self.filterCategory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.view.tintColor = UIColor(named: "colorAccent")
        alert.addAction(type)
        alert.addAction(category)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    private func filterType(){
        let alertController = UIAlertController(title: "Filter Type", message: nil, preferredStyle: .alert)
        let sellAction = UIAlertAction(title: "Sell", style: .default) { (action) in
            self.filterTypeSelected = "Sell"
            self.getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let requestAction = UIAlertAction(title: "Request", style: .default) { (action) in
            self.filterTypeSelected = "Request"
            self.getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterTypeSelected = "all"
            self.getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let cancelAction = UIAlertAction(title : "Cancel", style: .destructive) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.view.tintColor = UIColor(named: "colorAccent")
        alertController.addAction(sellAction)
        alertController.addAction(requestAction)
        alertController.addAction(allAction)
        alertController.addAction(cancelAction)
        
        var typeActionSelected : UIAlertAction
        
        switch filterTypeSelected {
        case "all":
            typeActionSelected = allAction
        case "Sell":
            typeActionSelected = sellAction
        case "Request":
            typeActionSelected = requestAction
        default:
            typeActionSelected = allAction
        }
        alertController.preferredAction = typeActionSelected
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func filterCategory(){
        let alertController = UIAlertController(title: "Filter Category", message: nil, preferredStyle: .alert)
        let regularAction = UIAlertAction(title: "Regular", style: .default) { (action) in
            self.filterCategorySelected = "Regular"
            self.getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let parkingAction = UIAlertAction(title: "Parking", style: .default) { (action) in
            self.filterCategorySelected = "Parking"
            self.getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterCategorySelected = "all"
            self.getHistory(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let cancelAction = UIAlertAction(title : "Cancel", style: .destructive) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.view.tintColor = UIColor(named: "colorAccent")
        alertController.addAction(regularAction)
        alertController.addAction(parkingAction)
        alertController.addAction(allAction)
        alertController.addAction(cancelAction)
        
        var categoryActionSelected : UIAlertAction
        
        switch filterCategorySelected {
        case "all":
            categoryActionSelected = allAction
        case "Regular":
            categoryActionSelected = regularAction
        case "Parking":
            categoryActionSelected = parkingAction
        default:
            categoryActionSelected = allAction
        }
        
        alertController.preferredAction = categoryActionSelected
        self.present(alertController, animated: true, completion: nil)
    }
}
