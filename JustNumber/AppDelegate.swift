//
//  AppDelegate.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import CallKit
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    static let ExtensionName = "com.accommate.test.IntentsExtension"
    
    var window: UIWindow?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("Finished launching with options: \(String(describing: launchOptions))")
        
        initRealm()
        
        return true
    }
    
    func reloadExtension(completionHandler completion: ((Error?) -> Swift.Void)? = nil){
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: AppDelegate.ExtensionName, completionHandler: completion)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("Open url: \(url)")
        
        
        return true
    }
    
    fileprivate func initRealm(){
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupID)!
            .appendingPathComponent("Library/Caches/default.realm")
        
        NSLog("fileURL = \(fileURL)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Saves changes in the application's managed object context before the application terminates.
        Storage.shared.save()
    }
}

