//
//  ViewController.swift
//  Form
//
//  Created by guarani on 04/21/2017.
//  Copyright (c) 2017 guarani. All rights reserved.
//

import UIKit
import Form

class User {
    var firstName: String?
    var lastName: String?
    var profession: String?
    var dateOfBirth: Date?
    var email: String?
    var username: String?
    var password: String?
    var github: String?
    var stackOverflow: String?
    
    var description: String? {
        return Mirror(reflecting: self).children.flatMap { $0 }.reduce("") { $0 + "\($1.label): \($1.value)" }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Form(in: self) { form in
            
            let user = User()
            
            Input(form).title("Enter your first name").placeholder("First name").bind { user.firstName = $0 }
            
            Input(form).title("Enter your last name").placeholder("Last name").bind { user.lastName = $0 }
            
            Picker(form, style: .embedded).placeholder("Profession").options([
                PickerOption("Construction worker 👷", "construction"),
                PickerOption("Astronaut 👩‍🚀", "astronaut"),
                PickerOption("Clerk 💁", "clerk"),
                PickerOption("Alchemist 👨‍🔬", "alchemist"),
                PickerOption("Hiring Manager 👨", "hn_manager"),
            ]).disable(row: 3).bind { user.profession = $0 }
            
            DatePicker(form, style: .keyboard).placeholder("Date of birth").bind(.onChange, .weekday, .shake).bind { user.dateOfBirth = $0 }
            
            Input(form).title("Email").placeholder("Enter your email address").bind { user.email = $0 }

            
            Input(form).title("Username").placeholder("Choose your username").bind(.submit, .max(10), .alert("Max 10 characters")).bind { user.username = $0 }
            
            Input(form).title("Password").placeholder("Enter a password").bind(.onChange, .max(10), .shake).bind(.onChange) {
                print($0.text)
            }.bind(.blur) { _ in
                print("bluuur")
            }.secure(true).key("password").bind { user.password = $0 }
            
            Switch(form).title("Add social media?").style {
                $0.`switch`.onTintColor = .red
                $0.`switch`.tintColor = .orange
            }.onToggle { isOn in
                print("isOn:", isOn)
            }.toggles {
                Input(form).title("Github profile").placeholder("URL").bind(.submit, .max(10), .alert("Max 10 characters")).bind { user.github = $0 }
                Input(form).title("StackOverflow profile").placeholder("URL").bind(.submit, .max(10), .alert("Max 10 characters")).bind { user.stackOverflow = $0 }
                Input(form).title("Twitter profile").placeholder("URL").bind(.submit, .max(10), .alert("Max 10 characters")).bind { user.stackOverflow = $0 }
            }
            

            
            Button(form) { _ in
                print(form.parameters)
                print(user.description)
            }.title("Gooooo!").style { sub in
                sub.view.layer.cornerRadius = 10
                sub.view.layer.masksToBounds = true
            }
            
        }.navigation(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

