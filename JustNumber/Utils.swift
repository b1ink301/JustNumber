//
//  File.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 15..
//  Copyright © 2017년 evan. All rights reserved.
//

import PhoneNumberKit

class Utils {
    static func makeItem(phone:String) -> (display:String, number:Int64)? {
        do {
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber = try phoneNumberKit.parse(phone, withRegion: "KR", ignoreType: true)
    
            let display = phoneNumberKit.format(phoneNumber, toType: .international)
            let tmp = phoneNumberKit.format(phoneNumber, toType: .e164)
            let index = tmp.index(tmp.startIndex, offsetBy: 1)
            let number = tmp[..<index]
            let intNumber = NumberFormatter().number(from: String(number))!.int64Value
            
            NSLog("number = \(number), intNumber = \(intNumber)")
            
            return (display:display, number:intNumber)
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        return nil
    }
    
}
