//
//  CoreDataStack.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 7..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CoreData


public class CoreDataStack {
    
    static let applicationDocumentsDirectoryName = "com.accommate.100bangTest"
//    static let mainStoreFileName = "Earthquakes.storedata"
    static let errorDomain = "CoreDataStack"
    
    static let EntityName = "Data"
    public static let appGroupID = "group.100bang"
    public static let modelName = "CKModel"
    static let ResourceName = "JustNumber"
    
    
    public static let shared = CoreDataStack()
//    lazy var coreDataStack = CoreDataStack()
    
    public var errorHandler: (Error) -> Void = {_ in }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: CoreDataStack.ResourceName, withExtension: CoreDataStack.modelName)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as NSURL
    
    }()
    
//    lazy var applicationSupportDirectory: URL = {
//        let fileManager = FileManager.default
//
//        // Use the app support directory directly if URLByAppendingPathComponent failed.
//        //
//        
//        let supportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
//        let applicationSupportDirectory = supportDirectory.appendingPathComponent(applicationDocumentsDirectoryName)
//        
//        do {
//            let properties = try (applicationSupportDirectory as NSURL).resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
//            
//            if let isDirectory = properties[URLResourceKey.isDirectoryKey] as? Bool, isDirectory == false {
//                let description = NSLocalizedString("Could not access the application data folder.", comment: "Failed to initialize applicationSupportDirectory.")
//                let reason = NSLocalizedString("Found a file in its place.", comment: "Failed to initialize applicationSupportDirectory.")
//                
//                throw NSError(domain: errorDomain, code: 201, userInfo: [
//                    NSLocalizedDescriptionKey: description,
//                    NSLocalizedFailureReasonErrorKey: reason
//                    ])
//            }
//        }
//        catch let error as NSError where error.code != NSFileReadNoSuchFileError {
//            fatalError("Error occured: \(error).")
//        }
//        catch {
//            let path = applicationSupportDirectory.path
//            
//            do {
//                try fileManager.createDirectory(atPath: path, withIntermediateDirectories:true, attributes:nil)
//            }
//            catch {
//                fatalError("Could not create application documents directory at \(path).")
//            }
//        }
//        return applicationSupportDirectory
//        
//    }()
//    
//    lazy var storeURL: URL = {
//        return self.applicationSupportDirectory.appendingPathComponent(mainStoreFileName)
//        
//    }()
    
    @available(iOS 10.0, *)
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            print("CoreData: Inited \(storeDescription)")
            guard error == nil else {
                print("CoreData: Unresolved error \(String(describing: error))")
                return
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        get {
            if #available(iOS 10.0, *) {
                return persistentContainer.viewContext
            } else {
                return managedObjectContext
            }
        }
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(CoreDataStack.ResourceName).sqlite")
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the
//        application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to
//        fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
//    //#1
//    lazy var persistentContainer: PersistentContainer = {
//        
////        let container = NSPersistentContainer(name: "CKModel")
//        let container = PersistentContainer(name: CoreDataStack.modelName)
//        
//        var persistentStoreDescriptions: NSPersistentStoreDescription
//        
//        let fileManager = FileManager.default
//        
//        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: CoreDataStack.appGroupID) else {
//            fatalError("groupURL fatal!!")
//        }
//        
////        let storeUrl = groupURL.appendingPathComponent("\(CoreDataStack.modelName).sqlite")
//        let storeUrl = groupURL.appendingPathComponent(CoreDataStack.modelName)
//        let storagePath = storeUrl.path
//        
////        try? fileManager.createDirectory(atPath: storeUrl.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
//        
//        // 2: Create a folder in the shared container location with name"CBLite"
//        if !fileManager.fileExists(atPath: storagePath) {
//            fatalError("error creating filepath: \(storagePath)")
//        }
//        
//        let description = NSPersistentStoreDescription()
//        description.shouldInferMappingModelAutomatically = true
//        description.shouldMigrateStoreAutomatically = true
//        description.url = storeUrl
//        
////        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeUrl)]
//        
//        container.persistentStoreDescriptions = [description]
//        
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("CoreDataStack : Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    //#2
//    public lazy var managedContext: NSManagedObjectContext = {
//        return self.persistentContainer.viewContext
//    }()
//    
//    //#3
//    // Optional
//    public lazy var backgroundContext: NSManagedObjectContext = {
//        return self.persistentContainer.newBackgroundContext()
//    }()
    
    //#4
    public func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.managedObjectContext.perform {
            block(self.context)
        }
    }
    
    //#5
//    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext)-> Void) {
//        self.managedObjectContext.bac
//    }
    
    //#6
    public func saveContext () {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("CoreDataStack : Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    public func getSortedItems() throws -> [CKItem] {
        var items = [CKItem]()
        
        do {
//            let fetchRequest: NSFetchRequest<CKItem> = CKItem.fetchRequest()
//            let sortData = NSSortDescriptor(key: #keyPath(CKItem.number), ascending: true)
//            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
//            fetchRequest.returnsObjectsAsFaults = false
//            
//            items = try managedContext.fetch(fetchRequest)
            items = try context.fetch(CKItem.fetchRequest())
        } catch {
            print("CoreDataStack: Error fetching data from CoreData")
        }
        
        return items
    }
    
    func add(name: String, display: String, number: Int64) {
    
        let entity = NSEntityDescription.entity(forEntityName: CoreDataStack.EntityName, in: context)
        
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        item.setValue(name, forKey: "name")
        item.setValue(display, forKey: "display")
        item.setValue(number, forKey: "number")
        
        saveContext()
    }
}
