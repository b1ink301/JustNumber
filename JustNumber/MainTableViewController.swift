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
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
//        let cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier, for: indexPath)
//        
//        let nameView = cell.viewWithTag(1) as! UILabel
//        let phoneView = cell.viewWithTag(2) as! UILabel
//        
//        let item = items[indexPath.row]
//        
//        nameView.text = item.name
////        phoneView.text = String.init(call.number)
//        phoneView.text = item.display
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
//        
//        parent?.performSegue(withIdentifier: ViewController.detailSegue, sender: item)
//    }
//    
//    
////    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return tableView.bounds.size.width
////    }
//    
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
////        let item = items[indexPath.row]
//        
//        do {
//            let item = items.remove(at: indexPath.row)
//            let context = Storage.shared.context
//            context.delete(item)
//            try context.save()
//            
//            AppDelegate.shared.reloadExtension(completionHandler: { (error) -> Void in
//                if let error = error {
//                    NSLog(error.localizedDescription)
//                }
//                else{
//                    NSLog("Successed fetching data from CoreData")
//                }
//            })
//
//        } catch let error as NSError {
//            NSLog("Fetch error: \(error) description: \(error.userInfo)")
//        }
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    
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
