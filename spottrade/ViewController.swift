//
//  ViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 3/20/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate    {
    
    var sidebarView: SidebarView!
    var blackScreen: UIView!
    
    var mapView:GMSMapView?
    let locationManager = CLLocationManager()

    override func loadView() {
        super.loadView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let newLocation = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 16)
        mapView?.animate(to: newLocation)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "colorPrimary")
        let btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu-50"), style: .plain, target: self, action: #selector(btnMenuAction))
        //btnMenu.tintColor = UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
        btnMenu.tintColor = UIColor(named: "colorAccent")
        self.navigationItem.leftBarButtonItem = btnMenu
        
        sidebarView = SidebarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.delegate = self
        sidebarView.layer.zPosition = 100
        self.view.isUserInteractionEnabled = true
        self.navigationController?.view.addSubview(sidebarView)
        
        blackScreen = UIView(frame: self.view.bounds)
        blackScreen.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden = true
        self.navigationController?.view.addSubview(blackScreen)
        blackScreen.layer.zPosition = 99
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.rotateGestures = false
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.791179, longitude: -74.139473)
        marker.title = "Bryant's Home"
        //marker.snippet = "Australia"
        marker.map = mapView
        
        getAvailableSpots(type: "all")
    }
    
    @objc func btnMenuAction() {
        blackScreen.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame = CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
        }) { (complete) in
            self.blackScreen.frame = CGRect(x: self.sidebarView.frame.width, y:0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height + 100)
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
    }
    
    func getAvailableSpots(type: String){
        Alamofire.request("http://192.168.1.153:3000/location/all?sellerID=all&transaction=available&type=" + type).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json =  JSON(value)
                    
                    print(json["location"])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        
        switch row {
        case .YourSpots:
            self.navigationController?.pushViewController(YourSpotsViewController(), animated: true)
        case .History:
            self.navigationController?.pushViewController(HistoryViewController(), animated: true)
        case .Feedback:
            self.navigationController?.pushViewController(FeedbackViewController(), animated: true)
        case .Payment:
             self.navigationController?.pushViewController(PaymentViewController(), animated: true)
        case .Personal:
            self.navigationController?.pushViewController(PersonalViewController(), animated: true)
        case .About:
            self.navigationController?.pushViewController(AboutViewController(), animated: true)
        case .LogOut:
            print("Sign Out")
        case .none:
            break
        case .Info:
            print("info")
        }
    }
}

