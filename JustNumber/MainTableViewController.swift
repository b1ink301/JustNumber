//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private let imageCellIdentifier = "textCell"
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
//        if let managedObjectContext = dataSource.managedObjectContext {
//            // Add Observer
//            let notificationCenter = NotificationCenter.default
//            notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object:managedObjectContext)
//        }
    }
    
    internal func reloadExtension() {
        let parent:ViewController = self.parent as! ViewController
        parent.reloadExtension()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        NotificationCenter.default.removeObserver(self);
    }
    
    // MARK: - Notification Handling
    
    internal func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("--- INSERTS ---")
            print(inserts)
            print("+++++++++++++++")
            
//            reloadExtension()
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("--- UPDATES ---")
            for update in updates {
                print(update.changedValues())
            }
            print("+++++++++++++++")
            
            
//            reloadExtension()
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            print("--- DELETES ---")
            print(deletes)
            print("+++++++++++++++")
            
//            reloadExtension()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionRefresh(_ sender: UIRefreshControl) {
        
//        self.tableView.reloadData()
        tableView.reloadData()
        
        sender.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewController.DetailSegue {
            guard let destinationController = segue.destination as? AddOrDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }

            destinationController.title = "상세"
            
            let item = dataSource.objectAtIndexPath(indexPath) as! CKItem
            
            destinationController.item = item
            destinationController.navigationItem.rightBarButtonItem = nil
            
            destinationController.completionHandler = { (data, status) -> Void in
                
                if data is CKItem {
                    switch status {
                    case .Delete:
                        if self.dataSource.delete(item: item){
                            NSLog("Delete...")
                            self.reloadExtension()
                        }
                    case .Update:
                        if Storage.shared.update(data: data as! CKItem){
                            NSLog("Updated...")
                            
                            self.reloadExtension()
                        }
                    default: break
                    }
                }
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}

class CKTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!

}
