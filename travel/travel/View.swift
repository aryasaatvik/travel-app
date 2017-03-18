//
//  View.swift
//  travel
//
//  Created by Trevor Aquino on 3/18/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import UIKit

class View: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Border
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red:0.52, green:0.79, blue:0.94, alpha:1.0).cgColor
        
    }
}
