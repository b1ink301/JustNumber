//
//  DataSource.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 13..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataSource: NSObject, UITableViewDataSource {
    private static let cellIdentifier = "textCell"
    
    fileprivate let tableView: UITableView
    
    lazy var managedObjectContext: NSManagedObjectContext! = {
        return Storage.shared.context
    }()
    
    lazy var fetchedResultsController: MainFetchedResultsController = {
        let controller = MainFetchedResultsController(managedObjectContext: self.managedObjectContext, withTableView: self.tableView)
        return controller
    }()
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> NSManagedObject {
        return fetchedResultsController.object(at: indexPath) as! NSManagedObject
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataSource.cellIdentifier, for: indexPath)
        return configureCell(cell, atIndexPath: indexPath)
    }
    
    fileprivate func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController.object(at: indexPath) as! CKItem

        let nameView = cell.viewWithTag(1) as! UILabel
        let phoneView = cell.viewWithTag(2) as! UILabel
        
        nameView.text = item.name
        phoneView.text = item.display

        return cell
    }
    
    func delete(item : NSManagedObject) -> Bool {
        managedObjectContext.delete(item)
        
        return Storage.shared.save() == .saved
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = fetchedResultsController.object(at: indexPath) as! NSManagedObject
        
        let _ = delete(item: item)
    }
    
}
