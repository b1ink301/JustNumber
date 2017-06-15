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
    
    @IBOutlet weak var containerView: UIView!
    
    static let MainSegue = "MainSegue"
    static let AddOrDetailSegue = "AddOrDetailSegue"
    static let DetailSegue = "DetailSegue"
    
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
            mainTableViewController = segue.destination as! MainTableViewController
        }
        else if segue.identifier == ViewController.AddOrDetailSegue {
            
            guard let destinationController = segue.destination as? AddOrDetailViewController else { return }
            destinationController.completionHandler = { (data, status) -> Void in
                if status == .Insert {
                    NSLog("Insert...")
                    self.reloadExtension()
                }
            }
        }
    }
    
    internal func reloadExtension() {
        AppDelegate.shared.reloadExtension(completionHandler: { (error) -> Void in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            else{
                let parent = self.navigationController as! BaseNaviagtionContoller
                parent.showToast(msg: "Successed fetching data from CoreData")
            }
        })
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        self.reloadExtension()
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        

        let alertController = UIAlertController(title: "연락처 등록", message: "새 연락처 추가합니다.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "저장", style: .destructive, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            if let name = firstTextField.text, let phone = secondTextField.text {
                NSLog("name = \(name), phone = \(phone)")
                
                
            }
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            if let string = UIPasteboard.general.string {
                textField.text = string
            }
            
            textField.placeholder = "Enter Phone Number"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

