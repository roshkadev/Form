//
//  Field.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit



/// Encapsulates behaviours common to all form fields.
public protocol Field: class {
    
    
    // #MARK: - Initializers
    
    // The field's requiered initializer for adding it to a row.
    init(row: Row)
    
    // The field's requiered initializer for adding it directly to a form (it's implicitly wrapped in a row).
    init(form: Form)
    
    // The field's internal initializer.
    init()
    
    
    // #MARK: - Others
    
    /// This field's containing field.
    var form: Form! { get set }
    
    /// This field's containing row.
    var row: Row! { get set }
    
    /// This field's view.
    var view: FieldView { get set }
    
    /// This field's stack view (its axis is either vertical, or horizontal) which is inside the field's view.
    var stackView: UIStackView { get set }
    
    /// This field's title.
    var title: String? { get set }
    
    /// This field's label.
    var label: FieldLabel? { get set }
    
    /// This field's padding.
    var padding: Space { get set }
    
    func setupStackViewWith(contentView: UIView)
    
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
    
    func didChangeContentSizeCategory()
}

/// Provides a default implementation for some field behaviours.
extension Field {
    
    @discardableResult
    public init(row: Row) {
        self.init()
        self.row = row
        row.add(field: self)
    }
    
    @discardableResult
    public init(form: Form) {
        self.init()
        self.form = form
        form.add(field: self)
    }
    
    public func setupStackViewWith(contentView: UIView) {

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        if let label = label {
            stackView.addArrangedSubview(label)
        }
        stackView.addArrangedSubview(contentView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: ["stackView": stackView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: ["stackView": stackView]))
    }

    
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
    
    public var key: String? {
        get { return nil }
        set { }
    }
    
    public var value: Any? { return nil }
    
    
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
    
    public func didChangeContentSizeCategory() {
        // Do nothing.
    }
}
