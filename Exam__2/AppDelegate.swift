//
//  AppDelegate.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 4/29/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        var viewVC = UIViewController()
        if !UserDefaults.standard.bool(forKey: "isUser"){
            viewVC = WelcomePage(nibName: "WelcomePage", bundle: nil)
        }else{
            viewVC = TabBars(nibName: "TabBars", bundle: nil)
        }
        window?.rootViewController = viewVC
        window?.makeKeyAndVisible()
        
        
        return true
    }

}

