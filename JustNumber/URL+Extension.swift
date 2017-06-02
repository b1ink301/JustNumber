//
//  URL+Extension.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 29..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation

extension URL: StartCallConvertible {
    
    private struct Constants {
        static let URLScheme = "justnumber"
    }
    
    var startCallHandle: String? {
        guard scheme == Constants.URLScheme else {
            return nil
        }
        
        return host
    }
    
}
