//
//  GoogleSignUpViewController.swift
//  Form
//
//  Created by Paul Von Schrottky on 5/20/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Form

// Someone already has that username. Note that we ignore periods and capitalization in usernames. Try another?
// Sorry, usernames of 8 or more characters must include at least one alphabetical character (a-z)
// That username is taken. Try another.
// Please use only letters (a-z), numbers, and periods.
// 


class GoogleSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Form(in: self, constructor: { form in
            
            Row(in: form) { row in
                
                Input(row: row, title: "Name").placeholder("First").bind(.onChange, .max(7), .help("xxx"))
                
                Input(row: row).placeholder("Last")
            }
            
            //.bind(.onChange, .regex("^(?(?=.{8,})(.*[a-z].*)|.*)"), .help("Sorry, usernames of 8 or more characters must include at least one alphabetical character (a-z)"))
            Input(form: form, title: "Choose your username").right(text: "@gmail.com", inset: 4).bind(.onChange, .max(3), .help("Blah blah"))
            //^(?(?=.{8,})(.*[a-z].*)|.*)
            
            Input(form: form, title: "Create a password")
            Input(form: form, title: "Confirm your password")
            
            Row(in: form) { row in
                Picker(row: row, title: "Birthday")
                Input(row: row).placeholder("Day")
                Input(row: row).placeholder("Year")
            }
            
            Picker(form: form, title: "Gender").placeholder("I am...").options([
                PickerOption("Female", "FEMALE"),
                PickerOption("Male", "MALE"),
                PickerOption("Other", "OTHER"),
                PickerOption("Rather not say", "NOTSAY")
            ])
            
            Picker(form: form, title: "Mobile phone").options([
                PickerOption("New Zealand +64", "+64"),
                PickerOption("Paraguay +595", "+595"),
                PickerOption("United Kingdom +44", "+44"),
                PickerOption("United States +1", "+1")
            ])
            
            Input(form: form).text("+595")
            
            Input(form: form, title: "Your current email address")
            
            Picker(form: form, title: "Location").options([
                PickerOption("New Zealand", "NZ"),
                PickerOption("Paraguay", "PY"),
                PickerOption("United Kingdom", "UK"),
                PickerOption("United States", "US")
            ])
            
            Button(form: form).title("Continue").style {
                $0.contentView.backgroundColor = .blue
            }
            
            
        
            
        })

    }

}
