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
                Input(row: row, title: "First name")
                Input(row: row, title: "Last name")
            }
            
            DatePicker(form: form)
            
        })

    }

}
