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
            

            // Add the instagram pastel header.
            let instaView = InstagramView(frame: self.view.bounds)
            form.add(view: instaView)
            instaView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            instaView.heightAnchor.constraint(equalToConstant: 140).isActive = true

            Input(form: form, padding: [.top(20), horizontal(16)]).placeholder("Phone number, username or email").style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }.bind(.formOnSubmit, .nonempty, .shake)

            Input(form: form).placeholder("Password").secure(true).style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }.bind(.formOnSubmit, .nonempty, .shake)
            
            Button(form: form).title("Login").style { button in
                button.button.backgroundColor = .blue
                button.button.layer.cornerRadius = 4
                button.button.layer.masksToBounds = true
                button.view.alpha = 0.5
            }.bind(.formOnChange) { loginButton in
                print(form.isValid)
                loginButton.view.alpha = form.isValid ? 1 : 0.5
            }
            
            
            let signinLabel = LinkLabel(title: "Forgot your login details? Get help signing in.", pattern: "\\Q Get help signing in.\\E", handler: {
                print("Sign in.")
            })
            form.add(view: signinLabel)
            
            Separator(form: form).title("OR").style {
                $0.label?.textColor = .gray
                $0.label?.font = UIFont.systemFont(ofSize: 11)
            }
            

            form.add(view: FacebookButton())

            
            let signupLabel = LinkLabel(title: "Don't have an account? Sign up.", pattern: "\\Q Sign up.\\E", handler: {
                print("Sign up")
            })
            form.add(view: signupLabel)

        }).navigation(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

class FacebookButton: UIButton {
    init() {
        super.init(frame: .zero)
        setTitleColor(.blue, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setImage(UIImage(named: "the-f"), for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        setTitle("Log In With Facebook", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LinkLabel: ActiveLabel {
    init(title: String, pattern: String, handler: @escaping ((Void) -> Void)) {
        super.init(frame: .zero)
        textAlignment = .center
        textColor = .gray
        font = UIFont.systemFont(ofSize: 12)
        text = title
        let customType = ActiveType.custom(pattern: pattern)
        enabledTypes = [ customType ]
        customColor[customType] =  .blue
        customSelectedColor[customType] = .blue
        customize { label in
            self.handleCustomTap(for: customType, handler: { e in
                handler()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
