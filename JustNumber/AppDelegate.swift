//
//  AppDelegate.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import CallKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    static let ExtensionName = "kr.b1ink.justnumber1.IntentsExtension"
    
    var window: UIWindow?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugPrint("Finished launching with options: \(String(describing: launchOptions))")
        
        if #available(iOS 13.0, *) {
//            UITableView.appearance().backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
//        UIApplication.shared.statusBarView?.backgroundColor = .green
        return true
    }
    
    func reloadExtension(completionHandler completion: ((Error?) -> Swift.Void)? = nil){
        CXCallDirectoryManager
            .sharedInstance
            .reloadExtension(withIdentifier: AppDelegate.ExtensionName,
                             completionHandler: completion)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        debugPrint("Open url: \(url)")
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Saves changes in the application's managed object context before the application terminates.
        Storage.shared.save()
    }
}

