//
//  Trip.swift
//  travel
//
//  Created by Saatvik Arya on 3/18/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class Trip {
    //MARK: Properties
    var name: String
    var author: String
    var collaborators = [String]()
    
    //MARK: Initialization
    init?(name: String, author: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.author = author        
    }
}
