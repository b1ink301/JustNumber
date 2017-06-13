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
    
    var item: CKItem! {
        
        didSet {
            DispatchQueue.main.async {
                self.nameTextField.text = self.item?.name
                self.numberLabel.text = self.item?.display
                self.memoTextView.text = self.item?.memo
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
        isUpdated = true
        
        if self.nameTextField == textField {
            self.item?.name = textField.text
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isUpdated = true
        
        if self.memoTextView == textView {
            self.item.memo = textView.text
        }
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        if isUpdated {
            self.completionHandler(self.item, false)
        }
    }
    

    @IBAction func actionDelete(_ sender: UIButton) {
        self.completionHandler(self.item, true)
        
        self.navigationController?.popViewController(animated: true);
    }
}
