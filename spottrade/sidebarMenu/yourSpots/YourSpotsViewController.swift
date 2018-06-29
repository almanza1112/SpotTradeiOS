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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Spots"
        self.view.backgroundColor = UIColor.white
        
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
        
        getYourSpots(type: "all")
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
}
