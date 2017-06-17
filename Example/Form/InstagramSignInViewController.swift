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
            instaView.heightAnchor.constraint(equalToConstant: 145).isActive = true
            
            Input(form: form).placeholder("Phone number, username or email").style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }.bind(.formOnSubmit, .nonempty, .shake).top(36).horizontal(36).height(43).bottom(0).style {
                $0.contentView.backgroundColor = UIColor.foreground
                $0.contentView.layer.cornerRadius = 4
                $0.contentView.layer.masksToBounds = true
                $0.contentView.layer.borderColor = UIColor.border.cgColor
                $0.contentView.layer.borderWidth = 1 / UIScreen.main.scale
            }

            Input(form: form).placeholder("Password").secure(true).style { input in
                input.textField.font = UIFont.systemFont(ofSize: 11)
            }.bind(.formOnSubmit, .nonempty, .shake).top(15).horizontal(36).height(43).bottom(20).style {
                $0.contentView.backgroundColor = UIColor.foreground
                $0.contentView.layer.cornerRadius = 4
                $0.contentView.layer.masksToBounds = true
                $0.contentView.layer.borderColor = UIColor.border.cgColor
                $0.contentView.layer.borderWidth = 1 / UIScreen.main.scale
            }
            
            Button(form: form).title("Login").style { button in
                button.button.backgroundColor = .blue
                button.button.layer.cornerRadius = 4
                button.button.layer.masksToBounds = true
                button.contentView.backgroundColor = .disabled
                button.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            }.bind(.formOnChange) { loginButton in
                print(form.isValid)
                loginButton.contentView.backgroundColor = form.isValid ? .enabled : .disabled
            }.height(44).horizontal(36).bottom(20)
            
            
            let signinLabel = LinkLabel(title: "Forgot your login details? Get help signing in.", pattern: "\\Q Get help signing in.\\E", handler: {
                print("Sign in.")
            })
            signinLabel.font = UIFont.boldSystemFont(ofSize: 10)
            form.add(view: signinLabel)
            
            Separator(form: form).title("OR").style {
                $0.label?.textColor = .gray
                $0.label?.font = UIFont.systemFont(ofSize: 11)
            }.horizontal(36).vertical(20)
            

            form.add(view: FacebookButton())

            
            let signupLabel = LinkLabel(title: "Don't have an account? Sign up.", pattern: "\\Q Sign up.\\E", handler: {
                print("Sign up")
            })
            signupLabel.font = UIFont.boldSystemFont(ofSize: 10)
            signupLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
            form.add(view: signupLabel)

        }).navigation(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension UIColor {
    static var foreground: UIColor { return UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) }
    static var background: UIColor { return UIColor.white }
    static var border: UIColor { return UIColor(red: 202/255.0, green: 202/255.0, blue: 202/255.0, alpha: 1) }
    static var disabled: UIColor { return UIColor(red: 157/255.0, green: 204/255.0, blue: 245/255.0, alpha: 1) }
    static var enabled: UIColor { return UIColor(red: 62/255.0, green: 154/255.0, blue: 237/255.0, alpha: 1) }
    static var link: UIColor { return UIColor(red: 62/255.0, green: 154/255.0, blue: 237/255.0, alpha: 1) }
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
        font = UIFont.systemFont(ofSize: 9)
        text = title
        let customType = ActiveType.custom(pattern: pattern)
        enabledTypes = [ customType ]
        customColor[customType] =  .link
        customSelectedColor[customType] = .link
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
