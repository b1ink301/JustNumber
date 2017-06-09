//
//  CallDirectoryHandler.swift
//  IntentsExtension
//
//  Created by evan on 2017. 5. 29..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CallKit
import CoreData

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        NSLog("beginRequest")
        
        context.delegate = self

//        do {
//            try addBlockingPhoneNumbers(to: context)
//        } catch {
//            NSLog("Unable to add blocking phone numbers")
//            let error = NSError(domain: "CallDirectoryHandler", code: 1, userInfo: nil)
//            context.cancelRequest(withError: error)
//            return
//        }

        do {
            try addIdentificationPhoneNumbers(to: context)
        } catch {
            NSLog("Unable to add identification phone numbers")
            let error = NSError(domain: "CallDirectoryHandler", code: 2, userInfo: nil)
            context.cancelRequest(withError: error)
            return
        }

        context.completeRequest()
    }

    private func addBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
        NSLog("addBlockingPhoneNumbers")
        
        // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 8217070759707, 82151449571 ]

        for phoneNumber in phoneNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }

    private func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
        NSLog("addIdentificationPhoneNumbers")
        
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        let managedObjectContext = Storage.shared.context;
        do {
            let fetchRequest: NSFetchRequest<CKItem> = CKItem.fetchRequest()
            let sortData = NSSortDescriptor(key: #keyPath(CKItem.number), ascending: true)
//            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
            fetchRequest.sortDescriptors = [sortData]
            fetchRequest.returnsObjectsAsFaults = false
            
//            items = try managedContext.fetch(fetchRequest)
//            let items = try managedObjectContext.fetch(CKItem.fetchRequest()) as [CKItem]
            
            let items = try managedObjectContext.fetch(fetchRequest) as [CKItem]
            
            for item in items {
                context.addIdentificationEntry(withNextSequentialPhoneNumber: item.number, label: item.name!)
            }
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        NSLog("An error occured when completing the request: \(error.localizedDescription)")

        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occured while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }
}
