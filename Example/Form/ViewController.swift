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
            
            let username = Input(form).placeholder("Enter your username").on(.submit, .max(10), .alert("Max 10 characters"))
            let password = Input(form).placeholder("Enter your password").on(.change, .max(10), .shake).on(.change) {
                print($0.text)
            }.on(.blur) { _ in
                print("bluuur")
            }.secure(true, pairedWith: username)
            let age = Input(form).placeholder("Enter your age").keyboardType(.numberPad)
            let color = Input(form).placeholder("Enter your favorite color")
            let submit = Submit(form).title("Gooooo!").style { sub in
                sub.view.layer.cornerRadius = 10
                sub.view.layer.masksToBounds = true

            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

