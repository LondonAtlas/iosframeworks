//
//  User.swift
//  MyFramework
//
//  Created by Tom Marks on 17/6/17.
//  Copyright © 2017 Tom Marks. All rights reserved.
//

import UIKit
import HelperFramework

public struct User {
    public var username: String? {
        get {
            return HFUserDefaults.shared.username
        }
        
        set {
            HFUserDefaults.shared.username = newValue
        }
    }
    
    public var firstName: String
    public var lastName: String
    
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
}
