//
//  Storage.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 7..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import CoreData

/// NSPersistentStoreCoordinator extension
extension NSPersistentStoreCoordinator {
    
    /// NSPersistentStoreCoordinator error types
    public enum CoordinatorError: Error {
        /// .momd file not found
        case modelFileNotFound
        /// NSManagedObjectModel creation fail
        case modelCreationError
        /// Gettings document directory fail
        case storePathNotFound
        
        case groupURLNotFound
    }
    
    /// Return NSPersistentStoreCoordinator object
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        NSLog("CoreData: coordinator : \(name)")
        
        
        guard let modelURL = Bundle.main.url(forResource: "JustNumber", withExtension: Storage.modelName) else {
            
            NSLog("CoreData: coordinator 1")

            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            
            NSLog("CoreData: coordinator 2")
            throw CoordinatorError.modelCreationError
        }
        
        let fileManager = FileManager.default
        
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Storage.appGroupID) else {
            
            NSLog("CoreData: coordinator 3")
            throw CoordinatorError.groupURLNotFound
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
//        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
//            throw CoordinatorError.storePathNotFound
//        }
        
        NSLog("CoreData: coordinator 4")
        do {
            let storeUrl = groupURL.appendingPathComponent("\(Storage.modelName).sqlite")
//            let url = documents.appendingPathComponent("\(name).sqlite")
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
                            NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
            
            NSLog("CoreData: coordinator 5")
        } catch {
            
            NSLog("CoreData: coordinator 6")
            throw error
            
        }
        
        return coordinator
    }
}

struct Storage {
    
    public static let modelName = "CKModel"
    public static let appGroupID = "group.100bang"

    static var shared = Storage()
    
    @available(iOS 10.0, *)
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = PersistentContainer(name: Storage.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            NSLog("CoreData: Inited \(storeDescription)")
            guard error == nil else {
                NSLog("CoreData: Unresolved error \(String(describing: error))")
                return
            }
        }
        return container
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: Storage.modelName)
        } catch {
            NSLog("CoreData: Unresolved error \(error)")
        }
        return nil
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: Public methods
    
    enum SaveStatus {
        case saved, rolledBack, hasNoChanges
    }
    
    var context: NSManagedObjectContext {
        mutating get {
            if #available(iOS 10.0, *) {
                return persistentContainer.viewContext
            } else {
                return managedObjectContext
            }
        }
    }
    
    mutating func save() -> SaveStatus {
        NSLog("CoreData: save")
        
        if context.hasChanges {
            do {
                try context.save()
                return .saved
            } catch {
                context.rollback()
                return .rolledBack
            }
        }
        return .hasNoChanges
    }
    
}
