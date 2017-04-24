//
//  Button.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/23/17.
//
//

import UIKit

final public class Submit: NSObject {
    
    // #MARK - Field
    public var view: UIView
    public var padding = Space.none
    
    var button: UIButton
    
    override public init() {
        
        view = UIView()
        button = UIButton()
        
        super.init()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)

        view.addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: button, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
    }
}

extension Submit: Field {

    public func isValid() -> (result: Bool, message: String?) {
        return (true, nil)
    }
    
}
