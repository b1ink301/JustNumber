//
//  ViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import PhoneNumberKit

class ViewController: UIViewController {
    static let MainSegue = "MainSegue"
    static let AddOrDetailSegue = "AddOrDetailSegue"
    static let DetailSegue = "DetailSegue"
    
    @IBOutlet weak var containerView: UIView!
    
    var mainTableViewController: MainTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewController.MainSegue {
            mainTableViewController = segue.destination as? MainTableViewController
        } else if segue.identifier == ViewController.AddOrDetailSegue {
            guard let destinationController = segue.destination as? AddOrDetailViewController else { return }
            destinationController.completionHandler = { (data, status) -> Void in
                if status == .insert {
                    debugPrint("Insert...")
                    self.reloadExtension()
                }
            }
        }
    }
    
    // Update CoreData
    internal func reloadExtension() {
        AppDelegate.shared.reloadExtension(completionHandler: { (error) -> Void in
            let parent = self.navigationController as! BaseNaviagtionContoller
            
            if let error = error {
                debugPrint(error.localizedDescription)
                parent.showToast(msg: error.localizedDescription)
            } else {
                parent.showToast(msg: "Successed fetching data from CoreData")
            }
        })
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        self.reloadExtension()
    }
}

