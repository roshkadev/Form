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

class InstagramSignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Form(in: self, constructor: { form in
            
            // Add the instagram pastel header.
            let instaView = InstagramView(frame: self.view.bounds)
            form.add(view: instaView)
            instaView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            instaView.heightAnchor.constraint(equalToConstant: 140).isActive = true


            Input(form: form).placeholder("Phone number, username or email").style { input in
//                input.padding.top = 40
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }

            Input(form: form).placeholder("Password").secure(true).style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }
            
            Separator(form: form).title("OR").style {
                $0.label?.textColor = .gray
                $0.label?.font = UIFont.systemFont(ofSize: 11)
                
            }

            Button(form: form).title("Login").style { button in
                button.button.backgroundColor = .blue
                button.button.layer.cornerRadius = 4
                button.button.layer.masksToBounds = true
            }

        })
    }
}

class InstagramView: PastelView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        startPastelPoint = .bottomLeft
        endPastelPoint = .topRight
        animationDuration = 3.0
        setColors([
            UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
            UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
            UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
            UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
            UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
            UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
            UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0),
        ])
        
        let instaImageView = UIImageView(image: UIImage(named: "Instagram Text Logo"))
        instaImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(instaImageView)
        instaImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        instaImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
