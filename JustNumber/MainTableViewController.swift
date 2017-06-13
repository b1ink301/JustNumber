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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewController.detailSegue {
            guard let destinationController = segue.destination as? DetailTableViewController, let indexPath = tableView.indexPathForSelectedRow else { return }

            destinationController.title = "Detail"
            
            let item = dataSource.objectAtIndexPath(indexPath) as! CKItem
            destinationController.item = item
            
            destinationController.completionHandler = { (data, isDeleted) -> Void in
                if isDeleted {
                    if self.dataSource.delete(item: item){
                        NSLog("Delete...")
                    }
                }
                else {
                    if Storage.shared.update(data: data){
                        NSLog("Updated...")
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
