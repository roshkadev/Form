//
//  Stepper.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit

final public class Stepper: NSObject {
    public var form: Form
    public var view: UIView
    public var label: UILabel
    public var stepper: UIStepper
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default
    public var key: String?
    public var value: Any? {
        return nil
    }
    
    
    @discardableResult
    public init(_ form: Form) {
        self.form = form
        view = UIView()
        label = UILabel()
        stepper = UIStepper()
        super.init()
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        view.addSubview(label)
        view.addSubview(stepper)
        
        // Label constraints.
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
        
        // Slider constraints.
        view.addConstraint(NSLayoutConstraint(item: stepper, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: stepper, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: stepper, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: stepper, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
        form.add { self }
        
        stepper.addTarget(self, action: #selector(stepAction), for: .valueChanged)
    }
    
    func stepAction(sender: UIStepper) {
        print(sender.value)
    }
    
    @discardableResult
    public func title(_ title: String?) -> Self {
        label.text = title
        return self
    }
}

extension Stepper: Field {
    
    public func didChangeContentSizeCategory() {
        label.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    @discardableResult
    public func style(_ style: ((Stepper) -> Void)) -> Self {
        style(self)
        return self
    }
}
