//
//  AppDelegate.swift
//  ExitekTask
//
//  Created by Nikita Kyrochka on 31.08.2022.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var NVC : UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        NVC = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = NVC
        window?.makeKeyAndVisible()
//        AppData.shared.loadData()
//        AppData.shared
        return true
    }


}

