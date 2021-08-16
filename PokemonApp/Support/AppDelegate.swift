//
//  AppDelegate.swift
//  PokemonApp
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let listRouter = ListRouter.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = listRouter.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

