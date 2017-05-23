//
//  InstagramSignInViewController.swift
//  Form
//
//  Created by Paul Von Schrottky on 5/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Form
import Pastel

//class InstaHeader: Field {
//    
//}

class InstagramSignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Form(in: self, constructor: { form in
            
            // Add the instagram pastel header.
            let pastelView = PastelView(frame: self.view.bounds)
            pastelView.startPastelPoint = .bottomLeft
            pastelView.endPastelPoint = .topRight
            pastelView.animationDuration = 3.0
            pastelView.setColors([
                UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0),
            ])
            pastelView.startAnimation()
            form.add(view: pastelView)
            pastelView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            pastelView.heightAnchor.constraint(equalToConstant: 140).isActive = true

            let instaImageView = UIImageView(image: UIImage(named: "Instagram Text Logo"))
            instaImageView.translatesAutoresizingMaskIntoConstraints = false
            pastelView.addSubview(instaImageView)
            instaImageView.centerXAnchor.constraint(equalTo: pastelView.centerXAnchor).isActive = true
            instaImageView.centerYAnchor.constraint(equalTo: pastelView.centerYAnchor).isActive = true
//            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(50)-[instaImageView]-(50)-|", options: [], metrics: nil, views: ["instaImageView": instaImageView]))
//            self.view.addConstraint(NSLayoutConstraint(item: instaImageView, attribute: .centerX, relatedBy: .equal, toItem: pastelView, attribute: .centerX, multiplier: 1, constant: 0))
            
            
            Input(form: form).placeholder("Phone number, username or email").style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }

            Input(form: form).placeholder("Password").secure(true).style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }

            Button(form: form).title("Login").style { button in
                button.button.backgroundColor = .blue
                button.button.layer.cornerRadius = 4
                button.button.layer.masksToBounds = true
            }

        })
    }

}
