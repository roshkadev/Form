//
//  Button.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/23/17.
//
//

import UIKit

/// An `ButtonEvent` is a user-interaction driven event associated with an `ButtonEvent`.
public enum ButtonEvent {
    case tap            // User taps button.
    case submit         // Same as `tap`, but transmits intent of submission to form. 
    case formOnChange   // The containing `Form` received a `FormEvent.onChange` event.
    case formOnSubmit   // The containing `Form` received a `FormEvent.onSubmit` event.
}

final public class Button: NSObject, Field {
    
    // #MARK - Field
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var contentView: UIView!
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var value: Any?
    public var topLayoutConstraint: NSLayoutConstraint?
    public var padding = Space.default
    
    public var button: UIButton
    
    public var formBindings = [(event: FormEvent, field: Field, handler: ((Field) -> Void))]()
    public var handlers = [(event: ButtonEvent, handler: ((Button) -> Void))]()
    
    public override init() {
        view = FieldView()
        stackView = UIStackView()
        if let title = title {
            label = FieldLabel()
            label?.text = title
        }
        button = UIButton()
        contentView = button
        super.init()
        
        setupStackViewWith(contentView: button)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
    }
    
    func action(button: UIButton) {
        
        // Fire any tap-related handlers for this button.
        handlers.filter { $0.event == .tap || $0.event == .submit }.forEach { $0.handler(self) }
    }
    
    public func didChangeContentSizeCategory() {
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }

    @discardableResult
    public func title(_ text: String?) -> Self {
        button.setTitle(text, for: .normal)
        return self
    }
    
    @discardableResult
    public func style(_ style: ((Button) -> Void)) -> Self {
        style(self)
        return self
    }
    
    @discardableResult
    public func bind(_ event: ButtonEvent, handler: @escaping ((Button) -> Void)) -> Self {
        
        switch event {
        case .tap:
            handlers.append((event, handler))
        case .submit:
            handlers.append((event, handler))
        case .formOnChange:
            formBindings.append((.onChange, self, { field in
                handler(self)
            }))
        case .formOnSubmit:
            formBindings.append((.onSubmit, self, { field in
                handler(self)
            }))
        }
        
        return self
    }
}
