//
//  AppDelegate.swift
//  GM Ceilings
//
//  Created by GM on 13.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Geoposition.update()
        UserDefaults.loadUser()
        
        if InternetConnection.isConnectedToNetwork() {
            PList.loadProperty()
            if UserDefaults.isFirstLoad() {
                ImagesLoader.loadImages()
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.instance.saveContext()
    }
}

