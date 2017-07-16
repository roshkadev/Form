//
//  Field.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit


public protocol Margin {
    func top(_ const: CGFloat) -> Field
    func right(_ const: CGFloat) -> Field
    func bottom(_ const: CGFloat) -> Field
    func left(_ const: CGFloat) -> Field
    func horizontal(_ const: CGFloat) -> Field
    func vertical(_ const: CGFloat) -> Field
    func width(_ const: CGFloat) -> Field
    func height(_ const: CGFloat) -> Field
}


/// Encapsulates behaviours common to all form fields.
public protocol Field: class, Margin {
    
    // #MARK: - Initializers
    
    // The field's requiered initializer for adding it to a row.
    init(row: Row)
    
    // The field's requiered initializer for adding it directly to a form (it is implicitly wrapped in a row).
    init(form: Form)
    
    init(form: Form, title: String?)
    
    // The field's internal initializer.
    init()
    
    
    // #MARK: - Others
    
    /// This field's containing field.
    var form: Form! { get set }
    
    /// This field's containing row.
    var row: Row! { get set }
    
    /// This field's view.
    var view: FieldView { get set }
    
    var contentView: UIView { get set }
    
    var helpLabel: HelpLabel { get set }
    
    /// This field's stack view (its axis is either vertical, or horizontal) which is inside the field's view.
    var stackView: UIStackView { get set }
    
    /// This field's title.
    var title: String? { get set }
    
    /// This field's label.
    var label: FieldLabel? { get set }
    
    /// This field's padding.
    var padding: Space { get set }
    
    func pad(_ padding: Space) -> Self
    
    func setupStackView()
    
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
    
    func isValid() -> Bool
    
    func isValidForSubmit() -> Bool
    
    var formBindings: [(event: FormEvent, field: Field, handler: ((Field) -> Void))] { get set }
}

/// Provides a default implementation for some field behaviours.
extension Field {
    
    @discardableResult
    public init(row: Row) {
        
        // Call the field's own initializer.
        self.init()
        
        self.row = row
        row.add(field: self)
    }
    
    @discardableResult
    public init(form: Form) {

        // Call the field's own initializer.
        self.init()

        form.add(field: self)
    }
    
    @discardableResult
    public init(row: Row, title: String?) {
        
        // Call the field's own initializer.
        self.init()
        
        self.title = title
        self.row = row
        row.add(field: self)
    }
    
    @discardableResult
    public init(form: Form, title: String?) {
        
        // Call the field's own initializer.
        self.init()
        
        self.title = title
        form.add(field: self)
    }
    
    public func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        if let label = label {
            stackView.addArrangedSubview(label)
        }
        stackView.addArrangedSubview(contentView)
        helpLabel.isHidden = true
        stackView.addArrangedSubview(helpLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        padding.topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top)
        padding.rightConstraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: stackView, attribute: .right, multiplier: 1, constant: padding.right)
        padding.bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1, constant: padding.bottom)
        padding.leftConstraint = NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left)
        view.addConstraints([padding.topConstraint, padding.rightConstraint, padding.bottomConstraint, padding.leftConstraint])
    }
    
    @discardableResult
    public func pad(_ padding: Space) -> Self {
        self.padding = padding
//        padding.topConstraint.constant = padding.top
//        padding.rightConstraint.constant = padding.right
//        padding.bottomConstraint.constant = padding.bottom
//        padding.leftConstraint.constant = padding.left
        return self
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
        } else {
            view.isHidden = true
        }
    }
    
    public func didChangeContentSizeCategory() {
        // Do nothing.
    }
    
    public func isValid() -> Bool {
        return true
    }
    
    public func isValidForSubmit() -> Bool {
        return true
    }
    
    // #MARK: - Some handy methods.
    
    static func isEmpty(text: String?) -> Bool {
        return trimmed(text: text).isEmpty == true
    }
    
    static func trimmed(text: String?) -> String {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    static func length(text: String?) -> Int {
        return text?.characters.count ?? 0
    }
    
    static func trimmedLength(text: String?) -> Int {
        return trimmed(text: text).characters.count ?? 0
    }
    
    static func textAfterReplacingCharactersIn(range: NSRange, replacementString string: String, inText text: String?) -> String {
        return (text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
    }
}

extension Field {
    
    @discardableResult
    public func top(_ const: CGFloat) -> Field {
        padding.topConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func right(_ const: CGFloat) -> Field {
        padding.rightConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func bottom(_ const: CGFloat) -> Field {
        padding.bottomConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func left(_ const: CGFloat) -> Field {
        padding.leftConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func horizontal(_ const: CGFloat) -> Field {
        padding.leftConstraint.constant = const
        padding.rightConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func vertical(_ const: CGFloat) -> Field {
        padding.topConstraint.constant = const
        padding.bottomConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func width(_ const: CGFloat) -> Field {
        padding.topConstraint.constant = const
        return self
    }
    
    @discardableResult
    public func height(_ const: CGFloat) -> Field {
        if let constraint = padding.heightConstraint {
            constraint.constant = const
        } else {
            padding.heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: const)
            view.addConstraint(padding.heightConstraint)
        }
        return self
    }
}
