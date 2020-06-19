//
//  LocalizableViews.swift
//  hundredbang
//
//  Created by Marcus Hong on 5/16/16.
//  Copyright © 2016 accommate. All rights reserved.
//

import UIKit

extension UITabBarItem {
    @IBInspectable var localizedText: String? {
        get {
            return title
        }
        set {
            if let str = newValue {
                title = localizedString(str)
            }
        }
    }
}

extension UILabel {
    @IBInspectable var localizedText: String? {
        get {
            return text
        }
        set {
            if let str = newValue {
                text = localizedString(str)
            }
        }
    }
}

extension UIButton {
    @IBInspectable var localizedText: String? {
        get {
            return title(for: .normal)
        }
        set {
            if let str = newValue {
                setTitle(localizedString(str), for: .normal)
            }
        }
    }
}

extension UITextField {
    @IBInspectable var localizedText: String? {
        get {
            return placeholder
        }
        set {
            if let str = newValue {
                placeholder = localizedString(str)
            }
        }
    }
}

extension UIViewController {
    @IBInspectable var localizedText: String? {
        get {
            return title
        }
        set {
            if let str = newValue {
                title = localizedString(str)
            }
        }
    }
}

fileprivate func localizedString(_ localizedText: String?) -> String {
    guard let localizedText = localizedText else {
        return ""
    }
    #if TARGET_INTERFACE_BUILDER
        let bundle = Bundle(for: type(of: self))
        return bundle.localizedString(forKey: self.localizedText, value:"", table: nil)
    #else
        return NSLocalizedString(localizedText, comment:"");
    #endif
}
