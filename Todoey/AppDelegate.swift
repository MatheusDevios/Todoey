//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        do {
            let _ = try Realm()
        } catch {
            print("Error initialising new ream, \(error)")
        }
        
        
        // Override point for customization after application launch.
        return true
    }


}

