//
//  AppDelegate.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 11/18/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appController = ApplicationController()

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    override init() {
        super.init()

        MapViewController.setDependencies(appController)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.tintColor = UIColor.ttTintColor()
        self.window?.backgroundColor = UIColor.black
        UINavigationBar.setDefaultAppearance()
        UITabBar.setDefaultAppearance() 
    
        SessionManager.default.session.configuration.httpAdditionalHeaders = [
            "Cache-Control":"no-cache",
            "Authorization":"Basic SU9TQ2xpZW50OklPU2lzdGhlYmVzdCEx",
            "Content-Type":"application/json",
        ]
        
        let _ = TrolleyScheduleService.sharedService
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

