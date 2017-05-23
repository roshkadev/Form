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
                Input(row: row)
                Input(row: row)
                Input(row: row)
            }
            
            Input(form: form)
            Input(form: form)
//            DatePicker(form)
//            Picker(form).title("Gender").placeholder("I am...").options([
//                PickerOption("Female"),
//                PickerOption("Male"),
//                PickerOption("Other"),
//                PickerOption("Rather not say"),
//            ])
        })

    }

}
