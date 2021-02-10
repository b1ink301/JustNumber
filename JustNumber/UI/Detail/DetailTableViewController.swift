//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailTableViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var spaceCell: UITableViewCell!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    
    var completionHandler: (NSObject, CompletionStatus) -> Void = { _,_  in }
    var status : CompletionStatus = .none
    var newName : String?
    var newMemo : String?
    
    var item: CKItem? {
        didSet {
            DispatchQueue.main.async {
                self.nameTextField.text = self.item?.name
                self.numberTextField.text = self.item?.display
                self.memoTextField.text = self.item?.memo
                
                // ReadOnly
                self.nameTextField.isUserInteractionEnabled = false
                self.memoTextField.isUserInteractionEnabled = false
                self.numberTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self as UITextFieldDelegate
        self.memoTextField.delegate = self as UITextFieldDelegate
        
        if self.item == nil {
            //            self.deleteCell.isHidden = true
            //            self.spaceCell.isHidden = true
            
            if let string = UIPasteboard.general.string {
                self.numberTextField.text = string
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func actionSave(_ sender: Any) {
        
        if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        }
        if self.memoTextField.isFirstResponder {
            self.memoTextField.resignFirstResponder()
        }
        
        if !isInvalid() {
            let parent = self.navigationController as! BaseNaviagtionContoller
            parent.showToast(msg: "입력 값을 확인해 주세요!")
            return
        }
  
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
    
    @IBAction func actionDelete(_ sender: Any) {
        self.completionHandler(self.item!, .delete)
        
        self.navigationController?.popViewController(animated: true);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MainViewController.EditSegue {
            guard let navigationController = segue.destination as? BaseNaviagtionContoller,
                  let destinationController = navigationController.viewControllers.first as? AddOrEditViewController else {return}
            
            //            destinationController.title = NSLocalizedString("meta_detail_title", comment: "")
            
            destinationController.item = item
            //            destinationController.navigationItem.rightBarButtonItem = nil
            destinationController.completionHandler = { (data, status) -> Void in
                if data is CKItem {
                    switch status {
                    case .delete: break
                    case .update: break
                        
                    default: break
                    }
                }
            }
        }
    }
}

extension DetailTableViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.nameTextField == textField {
            status = .update
            self.newName = textField.text
        } else if self.memoTextField == textField {
            status = .update
            self.newMemo = textField.text
        }
    }
}

