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

class AddOrEditViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var spaceCell: UITableViewCell!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var deleteCell: UITableViewCell!
    
    enum CompletionStatus : Int {
        case none
        case update
        case delete
        case insert
    }
    
    var completionHandler: (NSObject, CompletionStatus) -> Void = { _,_  in }
    var status : CompletionStatus = .none
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
            let data = Utils.makeItem(phone: self.numberTextField.text!)
            
            guard data != nil else {
                let parent = self.navigationController as! BaseNaviagtionContoller
                parent.showToast(msg: "전화 번호를 확인해 주세요.")
                self.numberTextField.becomeFirstResponder()
                return
            }
            
            guard !Storage.shared.hasNumber(number: data!.number) else {
                let parent = self.navigationController as! BaseNaviagtionContoller
                parent.showToast(msg: "이미 등롣된 번호입니다.")
                self.numberTextField.becomeFirstResponder()
                return
            }
            
            if Storage.shared.add(name: self.nameTextField.text!, display: data!.display, number: data!.number, memo: self.memoTextView.text!) {
                self.completionHandler(NSObject(), .insert)
                self.dismiss(animated: true)
            } else {
                let parent = self.navigationController as! BaseNaviagtionContoller
                parent.showToast(msg: "에러가 발생했습니다.")
            }
        } else {
            if status == .update {
                debugPrint("actionSave Update")
                
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
        self.completionHandler(self.item!, .delete)
        
        self.navigationController?.popViewController(animated: true);
    }
}

extension AddOrEditViewController : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.nameTextField == textField {
            status = .update
            self.newName = textField.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.memoTextView == textView {
            status = .update
            self.newMemo = textView.text
        }
    }
}
