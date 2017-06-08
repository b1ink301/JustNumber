//
//  AppDelegate.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import CoreData
//import PushKit
import CallKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
//    var deviceTokenString:String?
    
    //to register and receive voip notifications
//    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    
    let callManager = CallManager()
    var providerDelegate: ProviderDelegate?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("Finished launching with options: \(String(describing: launchOptions))")
        
//        pushRegistry.delegate = self
//        pushRegistry.desiredPushTypes = [.voIP]
        
        providerDelegate = ProviderDelegate(callManager: callManager)
                
        // Override point for customization after application launch.
        return true
    }
    
    func reloadExtension(completionHandler completion: ((Error?) -> Swift.Void)? = nil){
//        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.accommate.100bangTest.IntentsExtension", completionHandler: { (error) -> Void in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        })
        
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.accommate.test.IntentsExtension", completionHandler: completion)
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
        Storage.shared.save()
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        guard let handle = url.startCallHandle else {
//            print("Could not determine start call handle from URL: \(url)")
//            return false
//        }
//        
//        callManager.startCall(handle: handle)
//        return true
//    }
//    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        guard let handle = userActivity.startCallHandle else {
//            print("Could not determine start call handle from user activity: \(userActivity)")
//            return false
//        }
//        
//        guard let video = userActivity.video else {
//            print("Could not determine video from user activity: \(userActivity)")
//            return false
//        }
//        
//        callManager.startCall(handle: handle, video: video)
//        return true
//    }
    
    
    // MARK: - Core Data stack
    
//    lazy var managedObjectModel: NSManagedObjectModel = CoreDataStack.shared.managedObjectModel
    
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = Bundle.main.url(forResource: "JustNumber", withExtension: "CKModel")!
//        return NSManagedObjectModel(contentsOf: modelURL)!
//    }()
//    
////    lazy var persistentContainer: NSPersistentContainer = CoreDataStack.shared.persistentContainer
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let container = NSPersistentContainer(name: "CKModel")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
//    // MARK: - Core Data Saving support
//    
////    func saveContext () {
////        CoreDataStack.shared.saveContext()
////    }
//    func saveContext () {
//        NSLog("saveContext")
//        
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    // MARK: PKPushRegistryDelegate
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
//        NSLog("pushRegistry:didUpdatePushCredentials:forType:")
//        
//        if (type != .voIP) {
//            return
//        }
//        
//        let deviceToken = (credentials.token as NSData).description
//        
//        self.deviceTokenString = deviceToken
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenForType type: PKPushType) {
//        NSLog("pushRegistry:didInvalidatePushTokenForType:")
//        
//        if (type != .voIP) {
//            return
//        }
//        
//        self.deviceTokenString = nil
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
//        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:")
//        
//        guard type == .voIP else { return }
//        
//        if let uuidString = payload.dictionaryPayload["UUID"] as? String,
//            let handle = payload.dictionaryPayload["handle"] as? String,
//            let hasVideo = payload.dictionaryPayload["hasVideo"] as? Bool,
//            let uuid = UUID(uuidString: uuidString)
//        {
//            displayIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo)
//        }
//    }
    
    /// Display the incoming call to the user, through local notification metdata
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        NSLog("AppDelegate:displayIncomingCall")
        
        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    }

}

