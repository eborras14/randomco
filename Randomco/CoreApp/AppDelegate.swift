//
//  AppDelegate.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import UIKit
import VIPERPLUS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if window != nil {
            BaseRouter.setRoot(navigationController: HomeAssembly.navigationController())
        }
        return true
    }


}

