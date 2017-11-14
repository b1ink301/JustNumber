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
        
//        providerDelegate = ProviderDelegate(callManager: callManager)
        
        // Override point for customization after application launch.
        
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
    
    func initRealm(){
        
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupID)!
            .appendingPathComponent("Library/Caches/default.realm")
        
        NSLog("fileURL = \(fileURL)")
        

        
//        let config = Realm.Configuration(
//            // Get the URL to the bundled file
//            fileURL: Bundle.main.url(forResource: "MyBundledData", withExtension: "realm"),
//            // Open the file in read-only mode as application bundles are not writeable
//            readOnly: true)
//        
//        // Open the Realm with the configuration
//        let realm = try! Realm(configuration: config)
    }
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Saves changes in the application's managed object context before the application terminates.
        let _ = Storage.shared.save()
    }
    
    
    /// Display the incoming call to the user, through local notification metdata
//    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
//        NSLog("AppDelegate:displayIncomingCall")
//        
//        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
//    }

}

