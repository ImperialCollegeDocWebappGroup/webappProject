//
//  AppDelegate.swift
//  webapp
//
//  Created by Shan, Jinyi on 25/05/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

@UIApplicationMain class AppDelegate: UIResponder ,UIApplicationDelegate{
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        var pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.whiteColor()
        

        UITabBar.appearance().translucent = false
        UITabBar.appearance().backgroundImage = UIImage(named: "tabBar")
        UITabBar.appearance().tintColor = UIColor(red: (68/255.0), green: (154/255.0), blue: (211/255.0), alpha: 1.0)
        UITabBar.appearance().autoresizesSubviews = false
        UITabBar.appearance().clipsToBounds = true
    //    UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "American Typewriter", size: 20)], forState: .Normal)
        return true
        
        
    }
  
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        // when the app is launched in a website
               
        
        //  println(realURL)
        return true
        
    }
    
  
}