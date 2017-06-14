//
//  RequestHandler.swift
//  ShareLink
//
//  Created by evan on 2017. 6. 13..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
//import Contacts
import MobileCoreServices

class RequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let extensionItem = NSExtensionItem()
        
//        for (NSExtensionItem *item in self.extensionContext.inputItems) {
//            for (NSItemProvider *itemProvider in item.attachments) {
//                if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)@"vcf"]) {
//                    // This is an image. We'll load it, then place it in our image view.
//                    //                __weak UIImageView *imageView = self.imageView;
//                    [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeMPEG4 options:nil completionHandler:^(NSData *vcfFile, NSError *error) {
//                        if(vcfFile) {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        NSLog(@"%lu",(unsigned long)vcfFile.length);
//                        }];
//                        }
//                        }];
//                }
//            }
//        }
        
        
//        if let item = context.inputItems.first as? NSExtensionItem {
//            if let itemProvider = item.attachments?.first as? NSItemProvider {
//                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeVCard as String) {
//                    itemProvider.loadItem(forTypeIdentifier: kUTTypeVCard as String, options: nil, completionHandler: { (data, error) -> Void in
//                        if let data = data as? NSData {
//                            do{
////                                let phoneNumberKit = PhoneNumberKit()
////                                self.contact = try CNContactVCardSerialization.contacts(with: data as Data).first!
////                                self.title = self.contact?.phoneNumbers.first?.value.stringValue
//                                
//                                //                                let phoneNumber = try phoneNumberKit.parse(self.title!)
////                                let phoneNumber = try phoneNumberKit.parse(self.title!, withRegion: "KR", ignoreType: true)
////                                self.textView.text = phoneNumberKit.format(phoneNumber, toType: .e164)
//                            } catch {
////                                self.title = "error"
//                            }
//                        }
//                    })
//                }
//            }
//        }
    
        
        // The keys of the user info dictionary match what data Safari is expecting for each Shared Links item.
        // For the date, use the publish date of the content being linked
        extensionItem.userInfo = [ AnyHashable("uniqueIdentifier"): "uniqueIdentifierForSampleItem", AnyHashable("urlString"): "http://apple.com", AnyHashable("date"): NSDate() ]
        
        extensionItem.attributedTitle = NSAttributedString(string: "Sample title")
        extensionItem.attributedContentText = NSAttributedString(string: "Sample description text")
        
        // You can supply a custom image to be used with your link as well. Use the NSExtensionItem's attachments property.
        // extensionItem.attachments = [ NSItemProvider(contentsOf: Bundle.main().urlForResource("customLinkImage", withExtension: "png"))! ]

        context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }

}
