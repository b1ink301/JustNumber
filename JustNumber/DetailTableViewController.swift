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
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    
    var completionHandler: (CKItem, Bool) -> Void = {_,_  in }
    var isUpdated : Bool = false
    var newName : String?
    var newMemo : String?
    
    var item: CKItem? {
        didSet {
            DispatchQueue.main.async {
                self.nameTextField.text = self.item?.name
                self.numberLabel.text = self.item?.display
                self.memoTextView.text = self.item?.memo
            }
        }
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 메모리 해제
        disposeBag = DisposeBag()
    }
    
    let nameInputText = BehaviorSubject.init(value: "")
    let memoInputText = BehaviorSubject.init(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self as UITextFieldDelegate
        self.memoTextView.delegate = self as UITextViewDelegate
        
        let memoValid = self.memoTextView.rx.text.orEmpty
                            .map{ $0.count>3 }

        let nameValid = self.nameTextField.rx.text.orEmpty
                            .map{ $0.count>3 }
        
        
        self.navigationItem.rightBarButtonItem?
            .rx
            .tap
            .subscribe(onNext: { /*[weak self]*/ _ in
            
            })
            .disposed(by: disposeBag)
        
        nameValid
            .bind(to: nameTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        memoValid
            .bind(to: memoTextView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(nameValid, memoValid,resultSelector: { $0 && $1 })
            .subscribe(onNext: { b in
                
            })
            .disposed(by: disposeBag)
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
                self.item?.name = name
            }
            
            if let memo = self.newMemo {
                self.item?.memo = memo
            }
            
            self.completionHandler(self.item!, false)
        }
    }

    @IBAction func actionDelete(_ sender: UIButton) {
        self.completionHandler(self.item!, true)
        self.navigationController?.popViewController(animated: true);
    }
}

extension DetailTableViewController : UITextFieldDelegate {
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
}
