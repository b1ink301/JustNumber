//
//  ViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import PhoneNumberKit

class MainViewController: UIViewController {
    static let MainSegue = "MainSegue"
    static let AddSegue = "AddSegue"
    static let DetailSegue = "DetailSegue"
    
    @IBOutlet weak var containerView: UIView!
    
//    var mainTableViewController: MainTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MainViewController.MainSegue {
//            mainTableViewController = segue.destination as? MainTableViewController
        } else if segue.identifier == MainViewController.AddSegue {
            guard let destinationController = segue.destination as? AddOrEditViewController else { return }
            destinationController.title = "추가"
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
            DispatchQueue.main.async {
                if let parent = self.navigationController as? BaseNaviagtionContoller {
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        parent.showToast(msg: error.localizedDescription)
                    } else {
                        parent.showToast(msg: "Successed fetching data from CoreData")
                    }
                }
            }
        })
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        // TODO : 권한체크
        self.reloadExtension()
    }
}

