//
//  AlertView.swift
//  CoreData_Traning
//
//  Created by Rohit Makwana on 11/07/19.
//  Copyright © 2019 Rohit Makwana. All rights reserved.
//

import Foundation
import UIKit

final class AlertView {
    
    
    // MARK:- Show Alert
    //**********************************************************************
    // Show `Alert ViewController` using the default `title`, `message`, `actions`, `isShowCancel` and `viewController`.
    // `title`, `message`, `actions`, `isShowCancel` and `viewController`.
    //
    // - parameter title:             The title for Alert.
    // - parameter message:           The message for Alert.
    // - parameter actions:           The actions title for alert.
    // - parameter isShowCancel:      The isShowCancel Bool, base on show `Cancel` Action.
    // - parameter viewController:    The viewController on which have to display Alert.
    //
    //**********************************************************************

    class func showAlert(WithTitle title: String, AndMessage message: String, actions: [String], isShowCancel: Bool = false, viewController: UIViewController? = nil, completion: @escaping (UIAlertAction)->Void) {
        
        let alert = UIAlertController(title: title=="" ? nil:title, message: message=="" ? nil:message, preferredStyle: .alert)
        
        if title != "" {
            
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold)]
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            alert.setValue(titleAttrString, forKey: "attributedTitle")
        }
        
        if message != "" {
            
            let messageFont = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .medium)]
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(messageAttrString, forKey: "attributedMessage")
        }
        
        for act in actions {
            
            let alertAction = UIAlertAction(title: act, style: .default) { (action) in
                completion(action)
            }
            alert.addAction(alertAction)
        }
        
        if isShowCancel {
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancel)
        }
        
        if viewController != nil {
            viewController?.present(alert, animated: true, completion: nil)
        }
        else {
            appDelegate!.window?.rootViewController?.present(alert, animated: true) {}
        }
    }
    
    class func showAlert(WithTitle title: String, AndMessage message: String, action: String) {
        
        showAlert(WithTitle: title, AndMessage: message, actions: [action]) { (action) in }
    }
    
    class func showAlert(Withmessage message: String, action: String) {
        
        self.showAlert(WithTitle: "CoreData", AndMessage: message, action: action)
    }
}
