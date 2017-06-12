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
    
    static let mainSegue = "mainSegue"
    static let detailSegue = "DetailSegue"
    
    var mainTableViewController: MainTableViewController!
//    var detailTableViewController: DetailTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewController.mainSegue {
            mainTableViewController = segue.destination as! MainTableViewController
        }
        else if segue.identifier == ViewController.detailSegue {
            let detailTableViewController = segue.destination as! DetailTableViewController
            detailTableViewController.item = sender as? CKItem
            detailTableViewController.title = "Detail"
            
            detailTableViewController.completionHandler = { (data) -> Void in
                if Storage.shared.update(data: data){
                    NSLog("Updated...")
                    
                    self.mainTableViewController.reloadData()
                }
            }
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        
//        let spamUrl = SpamManager.shared().getSpamUrl("") as String
//        NSLog("url = \(spamUrl)")
        
        let alertController = UIAlertController(title: "연락처 등록", message: "새 연락처 추가합니다.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "저장", style: .destructive, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            if let name = firstTextField.text, let phone = secondTextField.text {
                NSLog("name = \(name), phone = \(phone)")
                
                do {
                    let phoneNumberKit = PhoneNumberKit()
//                    let phoneNumber = try phoneNumberKit.parse(phone, withRegion: "KR", ignoreType: true)
                    let phoneNumber = try phoneNumberKit.parse(phone)
                    let display = phoneNumberKit.format(phoneNumber, toType: .international)
                    var number = phoneNumberKit.format(phoneNumber, toType: .e164)
                    let index = number.index(number.startIndex, offsetBy: 1)
                    
                    number = number.substring(from: index)
                    
                    NSLog("number = \(number)")
                    
                    let intNumber = NumberFormatter().number(from: number)!.int64Value
                    
                    NSLog("number = \(number), intNumber = \(intNumber)")
                    
                    if( Storage.shared.add(name: name, display: display, number: intNumber) ){
                        self.mainTableViewController.reloadData()
                    }
                } catch let error as NSError {
                    NSLog("Fetch error: \(error) description: \(error.userInfo)")
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

