//
//  AppDelegate.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/1/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Register all services here
    private let serviceRegistry: ServiceRegistryImplementation = {
        
        QuoteServiceImplementation.register()
        KingfisherServiceImplementation.register()
        ImageDataServiceImplementation.register()
        
        return ServiceRegistry
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = QuotesRouter.createModule()
        window?.makeKeyAndVisible()
        
        return true
    }


}

