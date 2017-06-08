//
//  CoreDataManager.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    static let EntityName = "Data"
    
    let context = AppDelegate.shared.persistentContainer.viewContext
    
    var items = [CKItem]()
    
    func addItem(name: String, display: String, number: Int64) {
        
//        let item = CKItem(context: context)
//        
//        item.name = name
//        item.phone = phone
//        
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let entity =  NSEntityDescription.entity(forEntityName: CoreDataManager.EntityName, in: context)
        
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        
        //set the entity values
        item.setValue(name, forKey: "name")
        item.setValue(display, forKey: "display")
        item.setValue(number, forKey: "number")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }

        
    }
    
//    func categoryAtIndex(category: Category) -> Int {
//        
//        let i = categories.index{$0 === category}
//        return i!
//    }
    
    func updateItem(atIndex: Int, name: String, display: String) {
        
        let request = NSFetchRequest<CKItem>(entityName: CoreDataManager.EntityName)
        
        do {
            let searchResults = try context.fetch(request)
            
            searchResults[atIndex].name = name
            searchResults[atIndex].display = display
            
        } catch {
            print("Error with request: \(error)")
        }
        
        AppDelegate.shared.saveContext()
    }
    
    func getItems() -> [CKItem] {
        
        do {
            items = try context.fetch(CKItem.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        
        defaultItems()
        
        return items
    }
    
    func defaultItems() {
        
        if items.count == 0 {
            addItem(name: "test1", display: "1234-1234", number: 12345)
            addItem(name: "test2", display: "1234-1234", number: 23456)
            addItem(name: "test3", display: "1234-1234", number: 34567)
            addItem(name: "test4", display: "1234-1234", number: 45678)
        }
        
    }
}
