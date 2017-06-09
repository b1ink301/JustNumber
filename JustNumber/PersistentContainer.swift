//
//  JNPersistentContainer.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 7..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    internal override class func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        if let newURL =
            FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Storage.appGroupID) {
            url = newURL
        }
        return url
    }
}
