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
            Input().placeholder("Enter your username").blur(.range(3, 10)).text("paulvs")
        }.add {
            Input().placeholder("Enter your password").live(.max(10), .shake)
        }.add { Input()
            .placeholder("Enter your age")
            .keyboardType(.numberPad)
            .live(.currency(Locale.current))
        }.add {
            Input().placeholder("Enter your favorite color")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

