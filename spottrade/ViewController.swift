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

class ViewController: UIViewController, CLLocationManagerDelegate    {
    
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
        // Ask for authorization from user
        self.locationManager.requestAlwaysAuthorization()
        // For when in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: screenWidth, height: 300), camera: camera)
        mapView?.center = self.view.center
        self.view.addSubview(mapView!)
        
        // Creates a marker in the center of the map.
        /*
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        */
    }
    
    // Gets width of screen
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Gets height of screen
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

