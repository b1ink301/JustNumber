//
//  ShareViewController.swift
//  share
//
//  Created by evan on 2017. 6. 8..
//  Copyright © 2017년 evan. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Contacts
import PhoneNumberKit

class ShareViewController: SLComposeServiceViewController {

    var contact: CNContact?
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        for item in extensionContext?.inputItems as! [NSExtensionItem] {
//            // Iterate over items and look for an image
//            guard let attachments = item.attachments else { continue }
//            for itemProvider in attachments as! [NSItemProvider] {
//                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
//                    // This item can be represented as image, load it
//                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (imageData, error) in
//                        guard let imageData = imageData as? Data else {
//                            return
//                        }
//                        // TODO: Store data in an app group to make it accessible by PDF Viewer
//                    })
//                }
//            }
//        }
        
//        self.title = "test"
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
//            self.title = "test1"
            if let itemProvider = item.attachments?.first as? NSItemProvider {
//                self.title = "test2"
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeVCard as String) {
//                    self.title = "test3"
                    
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeVCard as String, options: nil, completionHandler: { (url, error) -> Void in
                        if let data = url as? NSData {
                            do{
                                let phoneNumberKit = PhoneNumberKit()
                                self.contact = try CNContactVCardSerialization.contacts(with: data as Data).first!
                                self.title = self.contact?.phoneNumbers.first?.value.stringValue
                                
//                                let phoneNumber = try phoneNumberKit.parse(self.title!)
                                let phoneNumber = try phoneNumberKit.parse(self.title!, withRegion: "KR", ignoreType: true)
                                self.textView.text = phoneNumberKit.format(phoneNumber, toType: .e164)
                            } catch {
                                self.title = "error"
                            }
                        }
                    })
                }
            }
        }

    }
    
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
//        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
//            if let itemProvider = item.attachments?.first as? NSItemProvider {
//                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
//                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
//                        if let shareURL = url as? NSURL {
//                            // do what you want to do with shareURL
//                            
//                            NSLog("shareURL = \(shareURL)")
//                        }
//                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
//                        
//                        return
//                    })
//                }
//            }
//        }
//        
//        extensionContext?.cancelRequest(withError: {} as! Error)
        
        if (self.contact != nil) {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        } else {
            extensionContext?.cancelRequest(withError: {} as! Error)
        }
        
        
    }

    lazy var editConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()!
        
        item.title = "연락처 등록"
        item.value = "등록"
        item.tapHandler = self.didSelectPost
        
        return item
    }()
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        
        
        return []
    }

}
