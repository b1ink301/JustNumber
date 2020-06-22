//
//  BaseNaviagtionController.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 15..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation

class BaseNaviagtionContoller: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showToast(msg:String) {
        DispatchQueue.main.async {
            let toast = UIAlertController()
            toast.message = msg;
            self.present(toast, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                toast.dismiss(animated: true)
            }
        }
    }
}
