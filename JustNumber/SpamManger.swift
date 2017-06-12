//
//  SpamManger.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 12..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation

class SpamManager {
    static var shared = SpamManager()
    
    static var MIN = 33456789
    static var MAX = 98765432
    
    func randomNumber(min: Int, max: Int)-> Int{
        return Int(arc4random_uniform(UInt32(max)) + UInt32(min));
    }
    
    func fackPhoneNumber() -> String {
        let r = randomNumber(min: SpamManager.MIN, max: SpamManager.MAX)

        return "010\(r)"
    }
}
