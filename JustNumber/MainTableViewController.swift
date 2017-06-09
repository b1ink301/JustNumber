//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    private let imageCellIdentifier = "textCell"
    
    var items: [CKItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    
    func reloadData(){
        NSLog("CKTableViewController:reloadData")
        
        let context = Storage.shared.context
        
        context.perform { 
            do {
                self.items = try context.fetch(CKItem.fetchRequest())
                
                AppDelegate.shared.reloadExtension(completionHandler: { (error) -> Void in
                    if let error = error {
                        NSLog(error.localizedDescription)
                    }
                    else{
                        NSLog("Successed fetching data from CoreData")
                    }
                })
            } catch {
                NSLog("Error fetching data from CoreData")
            }

        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier, for: indexPath)
        
        let nameView = cell.viewWithTag(1) as! UILabel
        let phoneView = cell.viewWithTag(2) as! UILabel
        
        let item = items[indexPath.row]
        
        nameView.text = item.name
//        phoneView.text = String.init(call.number)
        phoneView.text = item.display
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        parent?.performSegue(withIdentifier: ViewController.detailSegue, sender: item)
    
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.bounds.size.width
//    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
        
        do {
            let item = items.remove(at: indexPath.row)
            let context = Storage.shared.context
            context.delete(item)
            try context.save()
            
            AppDelegate.shared.reloadExtension(completionHandler: { (error) -> Void in
                if let error = error {
                    NSLog(error.localizedDescription)
                }
                else{
                    NSLog("Successed fetching data from CoreData")
                }
            })

        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

class CKTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!

}
