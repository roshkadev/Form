//
//  Form.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit

/// Encapsulates behaviours common to all form fields.
public protocol Field {

    /// This field's containing `Form`.
    var form: Form { get set }
    
    /// This field's view.
    var view: UIView { get set }
    
    /// The constraint used to show and hide the field.
    var bottomLayoutConstraint: NSLayoutConstraint? { get set }
    
    /// This field's padding.
    var padding: Space { get set }
    
    /// A closure to arbitrarily style the field.
    func style(_ style: ((Field) -> Void)) -> Self
    
    /// Return false if field could not become first responder, true otherwise.
    var canBecomeFirstResponder: Bool { get }
    
    /// Ask the field to become first responder, if possible.
    func becomeFirstResponder()
    
    /// Ask the field to resign first responder, if possible.
    func resignFirstResponder()
    
    /// A key associated with this field's value.
    var key: String? { get set }
    
    /// This field's value.
    var value: Any? { get }
}

/// Provides a default implementation for some field behaviours.
extension Field {
    
    public var canBecomeFirstResponder: Bool {
        return false
    }
    
    public func becomeFirstResponder() {
        // Do nothing.
    }
    
    public func resignFirstResponder() {
        // Do nothing.
    }
    
    var value: Any? { return nil }
}

class FormScrollView: UIScrollView {
    var form: Form!
}

public class Form: NSObject {
    
    var scrollView: FormScrollView
    var containingView: UIView
    var fields: [Field]
    var currentFirstResponder: UIView?
    var enableNavigation = true
    
    @discardableResult
    public init(in viewController: UIViewController, constructor: ((Form) -> Void)? = nil) {
        
        fields = []
        containingView = viewController.view
        scrollView = FormScrollView()
        
        super.init()
        
        scrollView.form = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(scrollView)
        let autolayoutViews: [String: Any] = [ "scrollView": scrollView ]
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        
        // Add the fields to the form.
        constructor?(self)
        
        // Register for keyboard notifications to allow form fields to avoid the keyboard.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    public var parameters: [String: Any]? {
        return fields.reduce([String: Any](), { partialResult, field in
            guard let key = field.key else { return partialResult }
            guard let value = field.value else { return partialResult }
            var updatedResult = partialResult
            updatedResult[key] = value
            return updatedResult
        })
    }
    
    deinit {
        print("Form deinitialized")
    }
}

extension Form {

    @discardableResult
    public func add(_ margin: Space = .default, _ add: ((Void) -> Field?)) -> Self {
        
        guard var field = add() else { return self }
        field.form = self
        
        scrollView.addSubview(field.view)
        
        if var lastField = fields.last, let bottomConstraint = lastField.bottomLayoutConstraint {
            // The form already contains one or more fields.
            
            containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .top, relatedBy: .equal, toItem: lastField.view, attribute: .bottom, multiplier: 1, constant: margin.top))
            containingView.removeConstraint(bottomConstraint)
            lastField.bottomLayoutConstraint = nil
            
        } else {
            // This field is the first field in the form.
            containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: margin.top))
        }
        
        containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1, constant: margin.left))
        containingView.addConstraint(NSLayoutConstraint(item: containingView, attribute: .right, relatedBy: .equal, toItem: field.view, attribute: .right, multiplier: 1, constant: margin.right))
        
        // Add constraints to make the scroll view use the width of the containing view.
        containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: margin.left))
        containingView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: field.view, attribute: .right, multiplier: 1, constant: margin.right))
        
        let bottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: field.view, attribute: .bottom, multiplier: 1, constant: Space.bottom.bottom)
        containingView.addConstraint(bottomConstraint)
        field.bottomLayoutConstraint = bottomConstraint
        
        fields.append(field)
        
        return self
    }
    
    @discardableResult
    public func navigation(_ navigation: Bool) -> Self {
        enableNavigation = navigation
        fields.flatMap { $0 as? Input }.forEach {
            if $0.textField.keyboardType == .numberPad || $0.textField.keyboardType == .decimalPad || $0.textField.keyboardType == .phonePad {
                $0.textField.inputAccessoryView = NextInputAccessoryView()
            } else {
                $0.textField.returnKeyType = .next
            }
        }
        
        fields.flatMap { $0 as? Picker }.forEach {
//            $0.textField?.inputAccessoryView = NextInputAccessoryView()
        }
        
        return self
    }
    
    func assign(firstResponder: UIView) {
        currentFirstResponder = firstResponder
    }
    
    /// Assign the next field as first responder.
    func didTapNextFrom(field: Field) {
        
        func moveFocus(fromField: Field, toField: Field) {
            if toField.canBecomeFirstResponder {
                toField.becomeFirstResponder()
            } else {
                fromField.resignFirstResponder()
                let offset = CGPoint(x: 0, y: field.view.frame.origin.y - scrollView.frame.height)
                scrollView.setContentOffset(offset, animated: true)
            }
        }
        
        let index = fields.index { $0.view == field.view }
        if let nextIndex = index?.advanced(by: 1), fields.indices.contains(nextIndex) {
            let nextField = fields[fields.startIndex.distance(to: nextIndex)]
            moveFocus(fromField: field, toField: nextField)
        } else {
            // Wrap around to bring focus to the first field in the form.
            if fields.indices.contains(fields.startIndex) {
                let nextField = fields[fields.startIndex]
                moveFocus(fromField: field, toField: nextField)
            }
        }
    }
}

extension Form {
    func keyboardWillShow(notification: Notification) {
        
        if let info = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue, let currentFirstResponder = currentFirstResponder {
            let keyboardHeight = info.cgRectValue.size.height
            let contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset

            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            var availableRect = containingView.frame
            availableRect.origin.y = statusBarHeight
            availableRect.size.height -= keyboardHeight - statusBarHeight
            if availableRect.contains(currentFirstResponder.frame) == false {
                print(scrollView.frame, scrollView.contentSize, currentFirstResponder.frame)
                let currentFirstResponderFrame = currentFirstResponder.frame.insetBy(dx: 0, dy: -16)
                scrollView.scrollRectToVisible(currentFirstResponderFrame, animated: true)
            }
            
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
