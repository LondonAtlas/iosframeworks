//
//  HFUserDefaults.swift
//  HelperFramework
//
//  Created by Tom Marks on 17/6/17.
//  Copyright © 2017 Tom Marks. All rights reserved.
//

import UIKit

// *************************************************************************************************
// MARK: - Constants

private let UsernameKey = "username"

// *************************************************************************************************
// MARK: - Class Implementation

public class HFUserDefaults: NSObject {
    
    // Singleton Object
    public static let shared = HFUserDefaults()
    
    // *********************************************************************************************
    // MARK: - Properties
    
    public var username: String? {
        get {
            return UserDefaults.standard.string(forKey: UsernameKey) ?? "No User name set"
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UsernameKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    // *********************************************************************************************
    // MARK: - Private functions
    
    // Setting init to private so the user can only use the singleton object.
    private override init() {
        super.init()
    }
}
