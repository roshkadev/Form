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
            
            let firstName = Input(form).placeholder("First name")
            
            let lastName = Input(form).placeholder("Last name")
            
            let profession = Picker(form, embedded: true).placeholder("Profession").options([
                PickerOption("Construction worker 👷", "construction"),
                PickerOption("Astronaut 👩‍🚀", "astronaut"),
                PickerOption("Clerk 💁", "clerk"),
                PickerOption("Alchemist 👨‍🔬", "alchemist"),
                PickerOption("Hiring Manager 👨", "hn_manager"),
            ]).disable(row: 3)
            
            let dateOfBirth = DatePicker(form, style: .embedded).placeholder("Date of birth").earliest(date: Date())
            
            let email = Input(form).placeholder("Email")

            
            let username = Input(form).placeholder("Choose your username").on(.submit, .max(10), .alert("Max 10 characters"))
            
            let password = Input(form).placeholder("Enter a password").on(.change, .max(10), .shake).on(.change) {
                print($0.text)
            }.on(.blur) { _ in
                print("bluuur")
            }.secure(true, pairedWith: username)
            
            let submit = Submit(form).title("Gooooo!").style { sub in
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

