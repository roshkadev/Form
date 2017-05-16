//
//  Field.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit

/// Encapsulates behaviours common to all form fields.
public protocol Field {
    
    /// This field's containing `Form`.
    var form: Form { get set }
    
    /// This field's view.
    var view: UIView { get set }
    
    /// This field's padding.
    var padding: Space { get set }
    
    /// The constraint used show/hide fields.
    var topLayoutConstraint: NSLayoutConstraint? { get set }
    
    /// The constraint that is adjusted to show/hide the next button, if applicable.
    var rightContainerLayoutConstraint: NSLayoutConstraint! { get set }
    var rightScrollLayoutConstraint: NSLayoutConstraint! { get set }
    
    /// A closure to arbitrarily style the field.
    func style(_ style: ((Self) -> Void)) -> Self
    
    /// Return false if field can not show a next button, true otherwise.
    var canShowNextButton: Bool { get }
    
    /// Return false if field could not become first responder, true otherwise.
    var canBecomeFirstResponder: Bool { get }
    
    /// Ask the field to become first responder, if possible.
    func becomeFirstResponder()
    
    /// Ask the field to resign first responder, if possible.
    func resignFirstResponder()
    
    ///
    var isContainedInGroup: Bool { get set }
    
    ///
    var peerFields: [Field] { get set }
    
    /// A key associated with this field's value.
    var key: String? { get set }
    
    /// This field's value.
    var value: Any? { get }
    
    // #MARK: - Visibility
    
    func show()
    
    func hide()
    
    func toggleVisibility()
}

/// Provides a default implementation for some field behaviours.
extension Field {
    
    public var canShowNextButton: Bool {
        return false
    }
    
    public var canBecomeFirstResponder: Bool {
        return false
    }
    
    public func becomeFirstResponder() {
        // Do nothing.
    }
    
    public func resignFirstResponder() {
        // Do nothing.
    }
    
    public var isContainedInGroup: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    public var peerFields: [Field] {
        get { return [] }
        set { }
    }
    
    var value: Any? { return nil }
    
    
    public func show() {}
    
    public func hide() {}
    
    public func toggleVisibility() {
        
        if view.isHidden {
            view.isHidden = false
            view.alpha = 0
            topLayoutConstraint?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 1
                self.form.scrollView.layoutIfNeeded()
            }, completion: { _ in
                
            })
        } else {
            topLayoutConstraint?.constant =  -view.frame.height
            view.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 0
                self.form.scrollView.layoutIfNeeded()
            }, completion: { _ in
                self.view.isHidden = true
            })
        }
    }
}
