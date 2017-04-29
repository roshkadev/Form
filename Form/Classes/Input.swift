//
//  Input.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit

final public class Input: NSObject, Field {
    
    public var form: Form
    public var view: UIView
    public var padding = Space.default
    var textField: UITextField
    
    public var validations = [Validation]()
    public var handlers = [(event: Event, handler: ((Input) -> Void))]()
    
    public init(_ form: Form) {
        
        self.form = form
        view = UIView()
        textField = UITextField()
        
        super.init()
        
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        
        view.addConstraint(NSLayoutConstraint(item: textField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: textField, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        form.add { self }
        
    }
    
    func editingChanged(textField: UITextField) {
        handlers.filter { $0.event == .change }.forEach { $0.handler(self) }
    }
    
    deinit {
        print("Input deinitialized")
    }
    
    public var text: String? {
        return textField.text
    }
    
    public func text(_ text: String?) -> Self {
        textField.text = text
        return self
    }

    public func placeholder(_ placeholder: String?) -> Self {
        textField.placeholder = placeholder
        return self
    }
    
    public func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        textField.keyboardType = keyboardType
        return self
    }
    
    public func secure(_ isSecure: Bool, pairedWith: Input? = nil) -> Self {
        textField.isSecureTextEntry = isSecure
        return self
    }
    
    public func validateForEvent(event: Event, with text: String?) -> Bool {
        
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasText = trimmedText.isEmpty == false
        let lengthOfText = trimmedText.characters.count
        
        let failingValidation: ValidationResult? = validations.map {
            switch $0 {
            case (event, .empty, let reaction):
                return (true, reaction)
            case (event, .nonempty, let reaction):
                return (hasText, reaction)
            case (event, .max(let max), let reaction):
                return (lengthOfText <= max, reaction)
            case (event, .min(let min), let reaction):
                return (lengthOfText >= min, reaction)
            case (event, .range(let min, let max), let reaction):
                return (lengthOfText > max || lengthOfText < min, reaction)
            default:
                return (true, .none)
            }
        }.filter { $0.isValid == false }.first
        
        if let failingValidation = failingValidation {
            switch failingValidation.reaction {
            case .shake:
                textField.shake()
            case .alert(let message):
                print(message)
            default:
                break
            }
            return false
        }
        
        return true
    }
}

extension Input: OnHandleEvent {

    public func on(_ event: Event, handler: @escaping ((Input) -> Void)) -> Self {
        handlers.append((event, handler))
        return self
    }
}

extension Input: OnValidationEvent {
    public func validateForEvent(event: Event) -> Bool {
        return validateForEvent(event: event, with: textField.text)
    }
}

extension Input: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Apply any change validations.
        return validateForEvent(event: .change, with: ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string))
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // Apply any blur callbacks.
        handlers.filter { $0.event == .blur }.forEach { $0.handler(self) }
        
        // Apply any blur validations.
        return validateForEvent(event: .blur, with: textField.text)
    }
}
