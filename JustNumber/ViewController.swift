//
//  ViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    let segTableViewController = "CKTableViewController"
    var tableViewController: CKTableViewController!
    
    //    var call:JNCall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segTableViewController {
            tableViewController = segue.destination as! CKTableViewController
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        //        tableViewController.reloadData()
        
        do{
            let context = Storage.shared.context
            
            let items = try context.fetch(CKItem.fetchRequest())
            
            if items.isEmpty {
                let entity = NSEntityDescription.entity(forEntityName: "Data", in: context)
                
                let item = NSManagedObject(entity: entity!, insertInto: context)
                
                //set the entity values
                item.setValue("test12345", forKey: "name")
                item.setValue("8216449571", forKey: "display")
                item.setValue(8216449571, forKey: "number")
                
                Storage.shared.save()
                
                self.tableViewController.reloadData()
            }
            else{
                AppDelegate.shared.reloadExtension(completionHandler: { (error) -> Void in
                    if let error = error {
                        NSLog(error.localizedDescription)
                    }
                    else{
                        NSLog("Successed fetching data from CoreData")
                    }
                })
                
            }
            
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        
        //        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        //        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
        //            AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: "07078759707", hasVideo: false) { _ in
        //                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        //            }
        //        }
        
        
        if true {
            return
        }
        
        let alertController = UIAlertController(title: "연락처 추가", message: "새 연락처 추가합니다.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "저장", style: .destructive, handler: {
            alert -> Void in
            
            NSLog("save")
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            if let name = firstTextField.text, let display = secondTextField.text {
                NSLog("name = \(name), display = \(display)")
                
                if let number = NumberFormatter().number(from: secondTextField.text!)?.int64Value {
                    NSLog("number = \(number)")
                    
                    //                    CoreDataStack.shared.add(name: firstTextField.text!, display: secondTextField.text!, number: number)
                    
                    let context = Storage.shared.context
                    let entity = NSEntityDescription.entity(forEntityName: "Data", in: context)
                    
                    let item = NSManagedObject(entity: entity!, insertInto: context)
                    
                    //set the entity values
                    item.setValue(name, forKey: "name")
                    item.setValue(display, forKey: "display")
                    item.setValue(number, forKey: "number")
                    
                    Storage.shared.save()
                    
                    self.tableViewController.reloadData()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Phone Number"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

