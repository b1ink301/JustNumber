//
//  StartCallConvertible.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 29..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation

protocol StartCallConvertible {
    var startCallHandle: String? { get }
    var video: Bool? { get }
}

extension StartCallConvertible {
    
    var video: Bool? {
        return nil
    }
    
}
