//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{
    
    
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    
    var completionHandler: (CKItem, Bool) -> Void = {_ in }
    var isUpdated : Bool = false
    var newName : String?
    var newMemo : String?
    
    var item: CKItem! {
        
        didSet {
            DispatchQueue.main.async {
                self.nameTextField.text = self.item.name
                self.numberLabel.text = self.item.display
                self.memoTextView.text = self.item.memo
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self as UITextFieldDelegate
        self.memoTextView.delegate = self as UITextViewDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.nameTextField == textField {
            isUpdated = true
            self.newName = textField.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.memoTextView == textView {
            isUpdated = true
            self.newMemo = textView.text
        }
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        
        if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        }
        if self.memoTextView.isFirstResponder {
            self.memoTextView.resignFirstResponder()
        }
        
        
        if isUpdated {
            isUpdated = false
            
            NSLog("actionSave")
            
            if let name = self.newName {
                self.item.name = name
            }
            
            if let memo = self.newMemo {
                self.item.memo = memo
            }
            
            self.completionHandler(self.item, false)
        }
    }
    

    @IBAction func actionDelete(_ sender: UIButton) {
        self.completionHandler(self.item, true)
        
        self.navigationController?.popViewController(animated: true);
    }
}
