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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [CKItem]()
    
    func addItem(name: String, phone: String) {
        
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
        item.setValue(phone, forKey: "phone")
        
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
    
    func updateItem(atIndex: Int, name: String, phone: String) {
        
        let request = NSFetchRequest<CKItem>(entityName: CoreDataManager.EntityName)
        
        do {
            let searchResults = try context.fetch(request)
            
            searchResults[atIndex].name = name
            searchResults[atIndex].phone = phone
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
            addItem(name: "test1", phone: "1234-1234")
            addItem(name: "test2", phone: "1234-1234")
            addItem(name: "test3", phone: "1234-1234")
            addItem(name: "test4", phone: "1234-1234")

            /*
            let item1 = CKItem(context: context)
            item1.name = "item1"
            item1.phone = "1234-1111"
            
            let item2 = CKItem(context: context)
            item2.name = "item2"
            item2.phone = "1234-2222"
            
            let item3 = CKItem(context: context)
            item3.name = "item3"
            item3.phone = "1234-3333"
            
            let item4 = CKItem(context: context)
            item4.name = "item4"
            item4.phone = "1234-4444"
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()*/
        }
        
    }
}
