//
//  TableViewController.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    
    var item: CKItem? {    
        
        didSet {
//            tableView.reloadData()
            
            DispatchQueue.main.async {
                self.nameTextField.text = self.item?.name
                self.numberLabel.text = self.item?.display
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

//class CKTableViewCell: UITableViewCell {
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var phone: UILabel!
//    
//}
