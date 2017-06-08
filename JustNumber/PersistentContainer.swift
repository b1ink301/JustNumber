//
//  JNPersistentContainer.swift
//  JustNumber
//
//  Created by evan on 2017. 6. 7..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CoreData

//extension NSPersistentContainer {
//    override func defaultDirectoryURL() -> URL {
//        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.100bang")!
//        
//        init() {
//            let modelURL = Bundle(for: CustomManagedObject.self).url(forResource: "JustNumber", withExtension: "CKModel")!
//            let model = NSManagedObjectModel(contentsOf: modelURL)!
//            super.init(name: "CKModel", managedObjectModel: model)
//        }
//}

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
