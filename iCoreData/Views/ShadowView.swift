//
//  ShadowView.swift
//  CoreData_Traning
//
//  Created by Rohit Makwana on 10/07/19.
//  Copyright © 2019 Rohit Makwana. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            
            if shadowRadius != 0 {
                
                layer.shadowColor   = UIColor.gray.cgColor
                layer.shadowOffset  = CGSize(width: 0, height: 0)
                layer.shadowOpacity = 0.35
                layer.shadowRadius  = shadowRadius
            }
        }
    }
}
