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

    var number:Int64 = 0
    var display:String?
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return !self.contentText.isEmpty && self.number != 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ERROR"

        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeVCard as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeVCard as String, options: nil, completionHandler: { (url, error) -> Void in
                        if let data = url as? NSData {
                            do{
                                let phoneNumberKit = PhoneNumberKit()
                                let contact = try CNContactVCardSerialization.contacts(with: data as Data).first!
                                
                                let phoneNumber = try phoneNumberKit.parse((contact.phoneNumbers.first?.value.stringValue)!, withRegion: "KR", ignoreType: true)
                                
                                let tmp = phoneNumberKit.format(phoneNumber, toType: .e164)
                                let index = tmp.index(tmp.startIndex, offsetBy: 1)
                                let number = tmp.substring(from: index)
                                
                                self.display = phoneNumberKit.format(phoneNumber, toType: .international)
                                self.number = NumberFormatter().number(from: number)!.int64Value
                                
                                self.editConfigurationItem.title = self.display
                                
                                self.title = "누구였지"
                                
                            } catch {
                                self.title = "ERROR #1"
                            }
                        }
                    })
                }
            }
        }
    }
    
    func finish() {
        self.number = 0;
        self.display = nil
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
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
        
        var isSuccessed = false
        if let name = self.contentText, let display = self.display {
            isSuccessed = Storage.shared.add(name: name, display: display, number: self.number)
        }

        let alert = UIAlertController(title:self.title, message: isSuccessed ? "성공" : "실패", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in self.finish() })
        self.present(alert, animated: true, completion: nil)

    }

    lazy var editConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()!
        
        item.title = "전화번호"
//        item.value = "등록"
//        item.tapHandler = self.didSelectPost
        
        return item
    }()
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        
        
        return [editConfigurationItem]
    }

}
