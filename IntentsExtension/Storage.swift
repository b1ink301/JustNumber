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
        // .momd file not found
        case modelFileNotFound
        // NSManagedObjectModel creation fail
        case modelCreationError
        // Gettings document directory fail
        case storePathNotFound
        // Gettings group URL fail
        case groupURLNotFound
    }
    
    /// Return NSPersistentStoreCoordinator object
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        guard let modelURL = Bundle.main.url(forResource: "JustNumber", withExtension: Storage.modelName) else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let fileManager = FileManager.default
        
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Storage.appGroupID) else {
            throw CoordinatorError.groupURLNotFound
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            let storeUrl = groupURL.appendingPathComponent("\(Storage.modelName).sqlite")
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
                            NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            throw error
        }
        
        return coordinator
    }
}

struct Storage {
    public static let entityName = "Data"
    public static let modelName = "CKModel"
    public static let appGroupID = "group.just.number"

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
    
    @discardableResult
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
    
    mutating func add(data:CKItem) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: Storage.entityName, in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        item.setValue(data.name, forKey: #keyPath(CKItem.name))
        item.setValue(data.display, forKey: #keyPath(CKItem.display))
        item.setValue(data.number, forKey: #keyPath(CKItem.number))
        item.setValue(NSDate(), forKey: #keyPath(CKItem.created_date))
        
        return save() == .saved
    }

    
    mutating func add(name:String, display:String, number:Int64, memo:String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: Storage.entityName, in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        item.setValue(name, forKey: #keyPath(CKItem.name))
        item.setValue(display, forKey: #keyPath(CKItem.display))
        item.setValue(number, forKey: #keyPath(CKItem.number))
        item.setValue(memo, forKey: #keyPath(CKItem.memo))
        item.setValue(NSDate(), forKey: #keyPath(CKItem.created_date))
        
        return save() == .saved
    }
    
    mutating func hasNumber(number:Int64) -> Bool {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Storage.entityName)
            fetchRequest.predicate = NSPredicate(format: "number = %d", number)
            let searchResults = try context.fetch(fetchRequest)
            return searchResults.count > 0
        } catch {
            print("Error with request: \(error)")
        }
        return false
    }

    mutating func update(data:CKItem) -> Bool {
        let fetchRequest: NSFetchRequest<CKItem> = CKItem.fetchRequest()
//        let fetchRequest = NSBatchUpdateRequest(entityName: Storage.entityName)
//        fetchRequest.predicate = NSPredicate(format: "number = %d", item.number)
        
        var hasItem:Bool = false
        do {
            let searchResults = try context.fetch(fetchRequest)
           
            for item in searchResults {
                if item.number == data.number {
                    item.name = data.name
                    item.display = data.display
                    
                    if data.memo != nil {
                        item.memo = data.memo
                    }
                    hasItem = true
                    break
                }
            }
        } catch {
            print("Error with request: \(error)")
        }
        return hasItem ? save() == .saved : false
    }
    
}
