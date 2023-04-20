//
//  AppDelegate.swift
//  MySwiftDemo
//
//  Created by milk on 2023/4/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setWindow()
        return true
    }
    func setWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = .white
            window.makeKeyAndVisible()
            let nav = UINavigationController(rootViewController: ViewController())
            window.rootViewController = nav
        }
    }

}

