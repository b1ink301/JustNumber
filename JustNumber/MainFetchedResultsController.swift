//
//  MainFetchedResultsController.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 13..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MainFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    fileprivate let tableView: UITableView
    
    init(managedObjectContext: NSManagedObjectContext, withTableView tableView: UITableView) {
        self.tableView = tableView
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Storage.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CKItem.created_date), ascending: true)
        request.sortDescriptors = [sortDescriptor]

        super.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch let error as NSError {
            print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update, .move:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default: break
            
        }
    }
    
}
