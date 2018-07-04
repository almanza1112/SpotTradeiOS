//
//  ViewController.swift
//  spottrade
//
//  Created by Bryant Almanza on 3/20/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate    {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    var sidebarView: SidebarView!
    var blackScreen: UIView!
    
    var mapView: GMSMapView?
    var marker: GMSMarker?
    let locationManager = CLLocationManager()
    
    var latArr: [Double] = []
    var lngArr: [Double] = []
    
    var filterTypeSelected = "all"
    var filterCategorySelected = "all"
    
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
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        self.searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        UISearchBar.appearance().tintColor = UIColor(named: "colorAccent")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
        let bMenu = UIBarButtonItem(image: UIImage(named: "menu_black"), style: .plain, target: self, action: #selector(bMenuAction))
        bMenu.tintColor = UIColor(named: "colorAccent")
        
        let bCreateSpot = UIBarButtonItem(image: UIImage(named: "add_black"), style: .plain, target: self, action: #selector(bCreateSpotAction))
        bCreateSpot.tintColor = UIColor(named: "colorAccent")
        
        let bFilter = UIBarButtonItem(image: UIImage(named: "filter_black"), style: .plain, target: self, action: #selector(bFilterSpots))
        bFilter.tintColor = UIColor(named: "colorAccent")
        
        self.navigationItem.leftBarButtonItem = bMenu
        self.navigationItem.rightBarButtonItems = [bCreateSpot, bFilter]
        
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
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.791345, longitude: -74.139406, zoom: 16)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.settings.rotateGestures = false
        view = mapView
        
        getAvailableSpots(type: filterTypeSelected, category: filterCategorySelected)
    }
    
    @objc func bMenuAction() {
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
    
    @objc func bCreateSpotAction() {
        self.navigationController?.pushViewController(CreateSpotViewController(), animated: true)
    }
    
    @objc func bFilterSpots() {
        let alert = UIAlertController(title: "Filter Spots", message: nil, preferredStyle: .alert)
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
            self.getAvailableSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let requestAction = UIAlertAction(title: "Request", style: .default) { (action) in
            self.filterTypeSelected = "Request"
            self.getAvailableSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterTypeSelected = "all"
            self.getAvailableSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
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
            self.getAvailableSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let parkingAction = UIAlertAction(title: "Parking", style: .default) { (action) in
            self.filterCategorySelected = "Parking"
            self.getAvailableSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
        }
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterCategorySelected = "all"
            self.getAvailableSpots(type: self.filterTypeSelected, category: self.filterCategorySelected)
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
    
    func getAvailableSpots(type: String, category : String){
        Alamofire.request("http://192.168.1.153:3000/location/all?sellerID=all&transaction=available&type=" + type + "&category=" + category).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json =  JSON(value)
                    for (index,subJson):(String, JSON) in json["location"] {
                        let marker = GMSMarker()
                        var latitude : Double
                        var longitude : Double
                        var title : String
                    
                        latitude = subJson["latitude"].doubleValue
                        longitude = subJson["longitude"].doubleValue
                        title = subJson["name"].stringValue
                        
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        marker.title = title
                        marker.map = self.mapView
                    }
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
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        case .none:
            break
        case .Info:
            print("info")
        }
    }
}

// Handle the user's selection.
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16)
        mapView?.animate(to: camera)
        
        print("Place name: \(place.name)")
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        print(place.formattedAddress!)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

