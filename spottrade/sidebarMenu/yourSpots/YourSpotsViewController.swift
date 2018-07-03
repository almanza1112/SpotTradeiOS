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

class YourSpotsViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView?
    let cellID = "Example Cell"
    
    var typeArr: [String] = []
    var categoryArr: [String] = []
    var nameArr: [String] = []
    var addressArr: [String] = []
    var priceArr: [String] = []
    var latArr: [Double] = []
    var lngArr: [Double] = []
    var offersArr: [Int] = []
    var quantityArr: [Int] = []
    var dateTimeStartArr: [Double] = []
    var offerAllowedArr: [Bool] = []
    var descriptionArr: [String] = []
    
    var filterTypeSelected = "all"
    var filterCategorySelected = "all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Spots"
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_black"), style: .plain, target: self, action: #selector(filterYourSpots))
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView!)
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView?.backgroundColor = .white
        
        // collectionView settings
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView?.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        collectionViewFlowLayout.scrollDirection = .vertical
        
        collectionView?.register(YourSpotsCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
    }
    
    // UICollectiovViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return typeArr.count
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! YourSpotsCollectionViewCell
        //cell.backgroundColor = .cyan
        cell.autoLayoutCell()
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        let height = width / 3
        return CGSize(width: width, height: height)
    }
    
    private func getYourSpots(type : String, category: String){
        Alamofire.request("http://192.168.1.153:3000/location/yourspots?id=" + UserDefaults.standard.string(forKey: "logged_in_user_id")! + "&transaction=available&type=" + type + "&category=" + category).responseJSON { response in
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
    
    @objc func filterYourSpots(){
        let alert = UIAlertController(title: "Filter Your Spots", message: nil, preferredStyle: .alert)
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
            self.getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let requestAction = UIAlertAction(title: "Request", style: .default) { (action) in
            self.filterTypeSelected = "Request"
            self.getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterTypeSelected = "all"
            self.getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
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
            self.getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let parkingAction = UIAlertAction(title: "Parking", style: .default) { (action) in
            self.filterCategorySelected = "Parking"
            self.getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterCategorySelected = "all"
            self.getYourSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
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
