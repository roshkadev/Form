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
        
        Form(in: self).add {
            Input()
            .placeholder("Enter your username")
            .on(.change, .max(10)).on(.change) {
                print("First callback: ", $0.text)
            }.on(.change) {
                print("Second callback: ", $0.text)
            }.on(.blur) {
                print("Blur callback: ", $0.text)
            }
        }.add {
            Input()
            .placeholder("Enter your password")
            .on(.change, .max(10), .shake)
        }.add {
            Input()
            .placeholder("Enter your age")
            .keyboardType(.numberPad)
        }.add {
            Input()
            .placeholder("Enter your favorite color")
        }.add {
            Submit()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

