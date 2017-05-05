//
//  ViewController.swift
//  Form
//
//  Created by guarani on 04/21/2017.
//  Copyright (c) 2017 guarani. All rights reserved.
//

import UIKit
import Form

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Form(in: self) { form in
            
            Input(form).placeholder("First name").key("first_name")
            
            let lastName = Input(form).placeholder("Last name").key("last_name")
            
            let profession = Picker(form, style: .embedded).placeholder("Profession").options([
                PickerOption("Construction worker 👷", "construction"),
                PickerOption("Astronaut 👩‍🚀", "astronaut"),
                PickerOption("Clerk 💁", "clerk"),
                PickerOption("Alchemist 👨‍🔬", "alchemist"),
                PickerOption("Hiring Manager 👨", "hn_manager"),
            ]).disable(row: 3)
            
            let dateOfBirth = DatePicker(form, style: .keyboard).placeholder("Date of birth").bind(.onChange, .weekday, .shake)
            
            let email = Input(form).placeholder("Email").key("email")

            
            let username = Input(form).placeholder("Choose your username").bind(.submit, .max(10), .alert("Max 10 characters")).key("username")
            
            let password = Input(form).placeholder("Enter a password").bind(.onChange, .max(10), .shake).bind(.onChange) {
                print($0.text)
            }.bind(.blur) { _ in
                print("bluuur")
            }.secure(true, pairedWith: username).key("password")
            
            let submit = Button(form).title("Gooooo!").style { sub in
                sub.view.layer.cornerRadius = 10
                sub.view.layer.masksToBounds = true
            }
            
        }.navigation(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

