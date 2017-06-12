//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    
    var completionHandler: (CKItem) -> Void = {_ in }
    var isUpdated : Bool = false
    
    var item: CKItem? {    
        
        didSet {
//            tableView.reloadData()
            
            DispatchQueue.main.async {
                self.nameTextField.text = self.item?.name
                self.numberLabel.text = self.item?.display
                self.memoTextField.text = self.item?.memo
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self as UITextFieldDelegate
        self.memoTextField.delegate = self as UITextFieldDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isUpdated = true
        
        if self.nameTextField == textField {
            self.item?.name = textField.text
        }
        else if self.memoTextField == textField {
            self.item?.memo = textField.text
        }
        
        self.completionHandler(self.item!)
        
    }
}

//class CKTableViewCell: UITableViewCell {
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var phone: UILabel!
//    
//}
