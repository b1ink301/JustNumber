//
//  Array+Extention.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 29..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows {
        guard let index = try index(where: predicate) else {
            return
        }
        
        remove(at: index)
    }
    
}
