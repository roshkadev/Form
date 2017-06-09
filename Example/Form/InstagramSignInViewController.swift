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
import ActiveLabel
import TTTAttributedLabel

class InstagramSignInViewController: UIViewController {

    let label = ActiveLabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()

        Form(in: self, constructor: { form in

//            // Add the instagram pastel header.
//            let instaView = InstagramView(frame: self.view.bounds)
//            form.add(view: instaView)
//            instaView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//            instaView.heightAnchor.constraint(equalToConstant: 140).isActive = true

            Input(form: form)
//            Input(form: form).placeholder("Phone number, username or email").style { input in
////                input.padding.top = 40
//                input.textField.font = UIFont.systemFont(ofSize: 11)
//            }

//            Input(form: form).placeholder("Password").secure(true).style { input in
//                input.textField.font = UIFont.systemFont(ofSize: 11)
//            }
//            
//            
//            let label = ActiveLabel()
//            label.textAlignment = .center
//            label.textColor = .gray
//            label.font = UIFont.systemFont(ofSize: 12)
//            label.text = "Forgot your login details? Get help signing in."
//            let customType = ActiveType.custom(pattern: "\\Q Get help signing in.\\E")
//            label.enabledTypes = [ customType ]
//            label.customColor[customType] =  .blue
//            label.customSelectedColor[customType] = .blue
//            label.customize { label in
//                label.handleCustomTap(for: customType, handler: { e in
//                    print(e)
//                })
//            }
//            form.add(view: label)
//            
//            Separator(form: form).title("OR").style {
//                $0.label?.textColor = .gray
//                $0.label?.font = UIFont.systemFont(ofSize: 11)
//            }
//            
//            let button = UIButton()
//            button.setTitleColor(.blue, for: .normal)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//            button.setImage(UIImage(named: "the-f"), for: .normal)
//            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//            button.setTitle("Log In With Facebook", for: .normal)
//            form.add(view: button)
//
//            Button(form: form).title("Login").style { button in
//                button.button.backgroundColor = .blue
//                button.button.layer.cornerRadius = 4
//                button.button.layer.masksToBounds = true
//            }
//            
//            let signupLabel = ActiveLabel()
//            signupLabel.textAlignment = .center
//            signupLabel.textColor = .gray
//            signupLabel.font = UIFont.systemFont(ofSize: 12)
//            signupLabel.text = "Don't have an account? Sign up."
//            let signupCustomType = ActiveType.custom(pattern: "\\Q Sign up.\\E")
//            signupLabel.enabledTypes = [ signupCustomType ]
//            signupLabel.customColor[signupCustomType] =  .blue
//            signupLabel.customSelectedColor[customType] = .blue
//            signupLabel.customize { label in
//                signupLabel.handleCustomTap(for: signupCustomType, handler: { e in
//                    print(e)
//                })
//            }
//            form.add(view: signupLabel)

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
