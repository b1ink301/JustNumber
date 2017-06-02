//
//  ViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 22..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit

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
        //        CoreDataManager.sharedInstance.addItem(name: "test", phone: "11111")
        
        //        AppDelegate.shared.callManager.startCall(handle: "123456", video: false)
        //
        ////        tableViewController.reloadData()
        //
        //        sleep(5);
        //
        ////        AppDelegate.shared.callManager.end(call: call!)
        //
        //
        //        let call = AppDelegate.shared.callManager.calls[0];
        //
        //        AppDelegate.shared.callManager.end(call: call)
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        //            let call = AppDelegate.shared.callManager.calls.first;
        //
        //            AppDelegate.shared.callManager.end(call: call!)
        //        })
        
        
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
            AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: "123456", hasVideo: false) { _ in
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
    }
}

