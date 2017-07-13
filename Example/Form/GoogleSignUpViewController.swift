//
//  GoogleSignUpViewController.swift
//  Form
//
//  Created by Paul Von Schrottky on 5/20/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Form

class GoogleSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Form(in: self, constructor: { form in
            
            Row(in: form) { row in
                
                Input(row: row).placeholder("First").bind(.onChange, .max(7), .help("xxx"))
                
                Input(row: row).placeholder("Last")
            }
            
            Input(form: form, title: "Choose your username").bind(.onChange, .regex("^(?(?=.{8,})(.*[a-z].*)|.*)"), .help("Sorry, usernames of 8 or more characters must include at least one alphabetical character (a-z)"))
            
            
            //^(?(?=.{8,})(.*[a-z].*)|.*)
            
            DatePicker(form: form)
            
        })

    }

}
