//
//  AppDelegate.swift
//  PinEntryExample
//
//  Created by Bas van Kuijck on 31/10/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(nibName: "ViewController", bundle: nil)
        window?.makeKeyAndVisible()
        return true
    }
}
