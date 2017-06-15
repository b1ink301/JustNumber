//
//  AddOrDetailViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 15..
//  Copyright © 2017년 evan. All rights reserved.
//

//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit

class AddOrDetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var spaceCell: UITableViewCell!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var deleteCell: UITableViewCell!
    
    enum CompletionStatus : Int {
        case None
        case Update
        case Delete
        case Insert
    }
    
    var completionHandler: (NSObject, CompletionStatus) -> Void = {_ in }
    var status : CompletionStatus = .None
    var newName : String?
    var newMemo : String?
    
    var item: CKItem? {
        didSet {
            DispatchQueue.main.async {
                self.nameTextField.text = self.item?.name
                self.numberTextField.text = self.item?.display
                self.memoTextView.text = self.item?.memo
                
                // ReadOnly
                self.numberTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self as UITextFieldDelegate
        self.memoTextView.delegate = self as UITextViewDelegate
        
        if self.item == nil {
            self.deleteCell.isHidden = true
            self.spaceCell.isHidden = true
            
            if let string = UIPasteboard.general.string {
                self.numberTextField.text = string
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.nameTextField == textField {
            status = .Update
            self.newName = textField.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.memoTextView == textView {
            status = .Update
            self.newMemo = textView.text
        }
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func isInvalid() -> Bool {
        if let text = self.nameTextField!.text, text.isEmpty {
            print("nameTextField isEmpty")
            return false
        }
        
        if let text = self.numberTextField.text, text.isEmpty {
            print("nameTextnumberTextField isEmpty")
            return false
        }
        
        return true
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        
        if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        }
        if self.memoTextView.isFirstResponder {
            self.memoTextView.resignFirstResponder()
        }
        
        if !isInvalid() {
            let parent = self.navigationController as! BaseNaviagtionContoller
            parent.showToast(msg: "입력 값을 확인해 주세요!")
            return
        }
        
        if self.deleteCell.isHidden {
            // Insert Item
            
            status = .Insert
            
            let data = Utils.makeItem(phone: self.numberTextField.text!)
            
            guard data != nil else {
                let parent = self.navigationController as! BaseNaviagtionContoller
                parent.showToast(msg: "전화 번호를 확인해 주세요.")
                return
            }
            
            if Storage.shared.add(name: self.nameTextField.text!, display: data!.display, number: data!.number, memo: self.memoTextView.text!) {
                self.completionHandler(NSObject(), status)
                self.dismiss(animated: true) 
            }
            else {
                let parent = self.navigationController as! BaseNaviagtionContoller
                parent.showToast(msg: "에러가 발생했습니다.")
            }
            
        }
        else {
            if status == .Update {
                NSLog("actionSave Update")
                
                if let name = self.newName {
                    self.item?.name = name
                }
                
                if let memo = self.newMemo {
                    self.item?.memo = memo
                }
                
                self.completionHandler(self.item!, status)
            }
        }
    }
    
    
    @IBAction func actionDelete(_ sender: UIButton) {
        self.completionHandler(self.item!, .Delete)
        
        self.navigationController?.popViewController(animated: true);
    }
}

