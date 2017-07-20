//
//  ViewController.swift
//  MyApp
//
//  Created by Tom Marks on 17/6/17.
//  Copyright © 2017 Tom Marks. All rights reserved.
//

import UIKit
import MyFramework

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    var user = User(firstName: "test", lastName: "user")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usernameTextField.text = self.user.username
    }

    // *********************************************************************************************
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let username = textField.text {
            self.user.username = username
        } else {
            self.showNoUsernameAlert()
            return false
        }
        
        return false
    }
    
    // *********************************************************************************************
    // MARK: - Private functions
    
    func showNoUsernameAlert() {
        let alertController = UIAlertController(title: "No Username", message: "Be sure to add a username first", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        self.show(alertController, sender: self)
    }
    
}

