//
//  Input.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit

/// An `InputEvent` is an event associated with an `Input`.
public enum InputEvent {
    case shouldFocus    // Return `false` to disable `Input` focus.
    case focus          // The `Input` gained focus.
    case beforeChange   // The value of the `Input` has changed.
    case onChange       // The value of the `Input` has changed.
    case shouldBlur     // Return `false` to disable `Input` blur.
    case blur           // The `Input` lost focus.
    case submit         // The containing `Form` received a `FormEvent.submit` event.
}

/// An `InputRestriction` is an condition that an `Input` may satisfy.
public enum InputRestriction {
    case empty
    case nonempty
    case max(Int)
    case min(Int)
    case range(Int, Int)
    case regex(String)
    case email
    case url
}

/// A `InputReaction` is the response of an `Input` to an `InputRestriction`.
public enum InputReaction {
    case none
    case stop
    case outline
    case highlight
    case shake
    case alert(String)
    case popup(String)
    case submit(InputRestriction)
}

public typealias InputValidation = (event: InputEvent, restriction: InputRestriction, reaction: InputReaction)
public typealias InputValidationResult = (isValid: Bool, reaction: InputReaction)

public class InputKey {
    public var key: String?
    public init(_ key: inout String?) { self.key = key }
}

final public class Input: NSObject {
    
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var attachedTo: InputKey?
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    
    public var padding = Space.default
    
    public var textField: UITextField
    
    public var validations = [InputValidation]()
    public var handlers = [(event: InputEvent, handler: ((Input) -> Void))]()

    
    @discardableResult
    public override init() {

        view = FieldView()
        stackView = UIStackView()
        if let title = title {
            label = FieldLabel()
            label?.text = title
        }
        textField = UITextField()
        super.init()
        
        setupStackViewWith(contentView: textField)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    
    }
    
    @discardableResult
    public func bind(_ binding: @escaping ((String?) -> Void)) -> Self {
        bind(.onChange, handler: {
            binding($0.text)
        })
        return self
    }
    
    @discardableResult
    public func bind(_ event: InputEvent, _ restriction: InputRestriction) -> Self {
        validations.append(InputValidation(event, restriction, .stop))
        return self
    }
    
    @discardableResult
    public func bind(_ event: InputEvent, _ restriction: InputRestriction, _ reaction: InputReaction) -> Self {
        validations.append(InputValidation(event, restriction, reaction))
        return self
    }
    
    @discardableResult
    public func bind(_ event: InputEvent, handler: @escaping ((Input) -> Void)) -> Self {
        handlers.append((event, handler))
        return self
    }
    
    public func validateForEvent(event: InputEvent, with text: String? = nil) -> Bool {
        
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasText = trimmedText.isEmpty == false
        let lengthOfText = trimmedText.characters.count
        
        let failingValidation: InputValidationResult? = validations.map {
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
    
    func editingChanged(textField: UITextField) {
        handlers.filter { $0.event == InputEvent.onChange }.forEach { $0.handler(self) }
        form.handlers.filter { $0.event == FormEvent.onChange }.forEach { $0.handler() }
    }
    
    public var value: Any? {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false {
            return text
        }
        return nil
    }
    
    public var isEmpty: Bool {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false {
            return false
        } else {
            return true
        }
    }
    
    public var text: String? {
        return textField.text
    }
    
    @discardableResult
    public func key(_ key: String?) -> Self {
        self.key = key
        return self
    }
    
    @discardableResult
    public func attach(_  to: inout InputKey) -> Self {
        to.key = "hello"
        self.attachedTo = to
        self.attachedTo?.key = "goodbye"
        return self
    }
    
    public func text(_ text: String?) -> Self {
        textField.text = text
        return self
    }

    @discardableResult
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
    
    deinit {
        print("Input deinitialized")
    }
}

extension Input: Field {
    
    @discardableResult
    public func style(_ style: ((Input) -> Void)) -> Self {
        style(self)
        return self
    }
    
    public var canShowNextButton: Bool {
        return true
    }
    
    public var canBecomeFirstResponder: Bool {
        return true
    }
    
    public func becomeFirstResponder(){
        textField.becomeFirstResponder()
    }
    
    public func resignFirstResponder(){
        textField.resignFirstResponder()
    }
    
    public func didChangeContentSizeCategory() {
        label?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    public func isValid() -> Bool {
        return validateForEvent(event: .onChange, with: textField.text)
    }
    
    public func isValidForSubmit() -> Bool {
        return validateForEvent(event: .submit)
    }

}

extension Input: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        form.assign(activeField: self)
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(form.fields.count)
        attachedTo?.key = textField.text
        return validateForEvent(event: .beforeChange, with: ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string))
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // Apply any blur handlers.
        handlers.filter { $0.event == .blur }.forEach { $0.handler(self) }
        
        // Apply any blur validations.
        return validateForEvent(event: .blur, with: textField.text)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType ==  .next {
            form.didTapNextFrom(field: self)
        }
        return true
    }
}
