//
//  AppDelegate.swift
//  spottrade
//
//  Created by Bryant Almanza on 3/20/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyAxgCqHg_WMgTNkBivxM5jpMWIhE4yinz8")
        GMSPlacesClient.provideAPIKey("AIzaSyAxgCqHg_WMgTNkBivxM5jpMWIhE4yinz8")
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor(named: "colorAccent")
        
        let userDefaults = UserDefaults.standard
        userDefaults.set("5b2248c2d118c83a5f0293be", forKey: "logged_in_user_id")
        userDefaults.set("Bryant", forKey: "logged_in_user_first_name")
        userDefaults.set("Almanza", forKey: "logged_in_user_last_name")
        userDefaults.set("almanza1112@gmail.com", forKey: "logged_in_user_email")
        userDefaults.set("+12014671007", forKey: "logged_in_user_phone_number")
        userDefaults.set("https://firebasestorage.googleapis.com/v0/b/spottrade-171321.appspot.com/o/Photos%2F5b2248c2d118c83a5f0293be%2FJPEG_20180614_065145_7353346688552332810.jpg?alt=media&token=077461a0-30cd-4220-b423-536ea6b5c1c0", forKey: "logged_in_user_photo_url")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window  = self.window {
            window.backgroundColor = UIColor.white
            var mainView : UIViewController
            if userDefaults.string(forKey: "logged_in_user_id") == nil {
                // If there is no UserDefault for logged_in_user_id then start LoginViewController
                mainView = LoginViewController()
            } else {
                // Else, there is a user logged in, proceed to ViewController
                mainView = ViewController()
            }
            let nav = UINavigationController()
            nav.viewControllers = [mainView]
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

