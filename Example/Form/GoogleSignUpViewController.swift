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
            
            Row(in: form) {
                Input(form, title: "Name")
                Input(form)
            }
            Input(form, title: "Choose your username")
            Input(form, title: "Create a password")
            Input(form, title: "Confirm your password")
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
