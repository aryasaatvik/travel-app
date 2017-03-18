//
//  TextField.swift
//  travel
//
//  Created by Trevor Aquino on 3/18/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Border
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red:0.52, green:0.79, blue:0.94, alpha:1.0).cgColor
        
    }
    
    let padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    
}
