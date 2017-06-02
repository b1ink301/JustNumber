//
//  CKItem+CoreDataProperties.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CoreData

extension CKItem {
    
    public static let EntityName = "Data"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CKItem> {
        return NSFetchRequest<CKItem>(entityName: EntityName);
    }
    
    @NSManaged public var name: String!
    @NSManaged public var phone: String!
}
