//
//  Button.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/23/17.
//
//

import UIKit

final public class Button: NSObject, Field {
    
    // #MARK - Field
    public var form: Form
    public var view: UIView
    public var key: String?
    public var value: Any?
    public var bottomLayoutConstraint: NSLayoutConstraint?
    public var padding = Space.none
    
    var button: UIButton
    
    var tapCallback: ((Button) -> Void)?
    
    public init(_ form: Form, onTap: @escaping ((Button) -> Void)) {
        
        self.form = form
        view = UIView()
        button = UIButton()
        tapCallback = onTap
        
        super.init()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        button.backgroundColor = UIColor.green
        
        view.addSubview(button)

        view.addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: button, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        form.add { self }
    }
    
    @discardableResult
    public func title(_ text: String?) -> Self {
        button.setTitle(text, for: .normal)
        return self
    }
    
    func action(button: UIButton) {
        tapCallback?(self)
    }
    
    @discardableResult
    public func style(_ style: ((Field) -> Void)) -> Self {
        style(self)
        return self
    }
}