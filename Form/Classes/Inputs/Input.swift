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
    case formOnChange   // The containing `Form` received a `FormEvent.onChange` event.
    case formOnSubmit   // The containing `Form` received a `FormEvent.onSubmit` event.
}

/// An `InputRestriction` is an condition that an `Input` may satisfy.
public indirect enum InputRestriction {
    case empty
    case nonempty
    case max(Int)
    case min(Int)
    case range(Int, Int)
    case regex(String)
    case email
    case url
    case not(InputRestriction)
}

/// A `InputReaction` is the response of an `Input` to an `InputRestriction`.
public enum InputReaction {
    case none
    case stop
    case outline
    case highlight
    case shake
    case help(String)
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
    public var contentView: UIView
    public var helpLabel = HelpLabel()
    public var stackView: UIStackView
    public var title: String? {
        didSet {
            label?.text = title
        }
    }
    public var label: FieldLabel?
    public var key: String?
    public var attachedTo: InputKey?
    
    public var padding = Space.default
    
    public var textField: TextField
    
    public var validations = [InputValidation]()
    public var handlers = [(event: InputEvent, handler: ((Input) -> Void))]()
    public var formBindings = [(event: FormEvent, field: Field, handler: ((Field) -> Void))]()
    
    @discardableResult
    public override init() {

        view = FieldView()
        stackView = UIStackView()
        label = FieldLabel()
        textField = TextField()
        contentView = textField
        super.init()
        
        setupStackView()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    
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
    public func bind(_ event: InputEvent, _ restriction: InputRestriction, _ reactions: [InputReaction]) -> Self {
        reactions.forEach { validations.append(InputValidation(event, restriction, $0)) }
        return self
    }
    
    @discardableResult
    public func bind(_ event: InputEvent, handler: @escaping ((Input) -> Void)) -> Self {
        handlers.append((event, handler))
        return self
    }
    
    @discardableResult
    public func bind(_ binding: @escaping ((String?) -> Void)) -> Self {
        bind(.onChange, handler: {
            binding($0.text)
        })
        return self
    }
    
//    public func validateForEvent(event: InputEvent, with text: String? = nil, react: Bool = true) -> Bool {
//        
//        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let hasText = trimmedText.isEmpty == false
//        let lengthOfText = trimmedText.characters.count
//        
//        let failingValidation: InputValidationResult? = validations.map {
//            
//            var res: InputValidationResult!
//            
//            switch $0 {
//            case (event, .empty, let reaction):
//                res = (true, reaction)
//            case (event, .nonempty, _):
//                res = (hasText, .shake)
//            case (event, .max(let max), let reaction):
//                print("MAX")
//                res = (lengthOfText <= max, reaction)
//            case (event, .min(let min), let reaction):
//                res = (lengthOfText >= min, reaction)
//            case (event, .range(let min, let max), let reaction):
//                res = (lengthOfText > max || lengthOfText < min, reaction)
//            case (event, .regex(let r), let reaction):
//                print("REGEX")
//                res = (trimmedText.range(of: r, options: .regularExpression) != nil, reaction)
//            default:
//                res = (true, .none)
//            }
//            
//            return res
//            
//        }.filter { $0.isValid == false }.first
//        
//        if let failingValidation = failingValidation {
//            
//            if react {
//                switch failingValidation.reaction {
//                case .shake:
//                    textField.shake()
//                case .outline:
//                    print("Outlined!!!")
//                case .help(let message):
//                    print(message)
//                case .alert(let message):
//                    print(message)
//                default:
//                    break
//                }
//            }
//            return false
//        }
//        
//        return true
//    }
    
    @discardableResult
    func fails(restriction: InputRestriction, forText: String? = nil) -> Bool {
        
        let textToCheck = forText ?? self.text
        
        switch restriction {
        case .empty where !Input.isEmpty(text: textToCheck):
            return true
        case .nonempty where Input.isEmpty(text: textToCheck):
            return true
        case .max(let max) where Input.trimmedLength(text: textToCheck) > max:
            return true
        case .min(let min) where Input.trimmedLength(text: textToCheck) < min:
            return true
        case .range(let min, let max) where Input.trimmedLength(text: textToCheck) < min || Input.trimmedLength(text: textToCheck) > max:
            return true
        case .regex(let r) where Input.trimmed(text: textToCheck).range(of: r, options: .regularExpression) != nil:
            return true
        default:
            return false
        }
    }
    
    func apply(reaction: InputReaction?) {
        guard let reaction = reaction else { return }
        switch reaction {
        case .shake:
            textField.shake()
        case .outline:
            print("Outlined!!!")
        case .help(let message):
            self.helpLabel.text = message
            self.helpLabel.isHidden = false
            
        case .alert(let message):
            print(message)
        default:
            break
        }
    }
    
    func editingChanged(textField: UITextField) {
        let reaction = validations.filter {
            $0.event == .onChange
        }.first {
            fails(restriction: $0.restriction)
        }?.reaction
        apply(reaction: reaction)
        
        
//        handlers.filter { $0.event == InputEvent.onChange }.forEach { $0.handler(self) }
//        
//        let formBindings = form.fields.flatMap { $0.formBindings }.filter { $0.event == .onChange }.forEach { (event, field, handler) in
//            handler(field)
//        }
//        
//        
////        form.handlers.filter { $0.event == FormEvent.onChange }.forEach { $0.handler(self) }
    }
    
    public var value: Any? {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false {
            return text
        }
        return nil
    }
    
    public var trimmedText: String {
        return Input.trimmed(text: text)
    }
    
    public var length: Int {
        return Input.trimmedLength(text: text)
    }
    
    public var isEmpty: Bool {
        return Input.isEmpty(text: text)
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
    
    @discardableResult
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
    
    @discardableResult
    public func left(text: String, mode: UITextFieldViewMode = .always, inset: CGFloat = 0) -> Self {
        let leftLabel = UILabel()
        leftLabel.text = text
        textField.leftViewInset = inset
        textField.leftViewMode = mode
        textField.leftView = leftLabel
        return self
    }
    
    @discardableResult
    public func right(text: String, mode: UITextFieldViewMode = .always, inset: CGFloat = 0) -> Self {
        let rightLabel = UILabel()
        rightLabel.text = text
        textField.rightViewInset = inset
        textField.rightViewMode = mode
        textField.rightView = rightLabel
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
//        return validateForEvent(event: .onChange, with: textField.text)
        return true
    }
    
    public func isValidForSubmit() -> Bool {
//        return validateForEvent(event: .formOnSubmit, with: textField.text, react: false)
        return true
    }

}

extension Input: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        form.assign(activeField: self)
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        attachedTo?.key = textField.text
        
        let text = Input.textAfterReplacingCharactersIn(range: range, replacementString: string, inText: textField.text)
        return validations.filter { $0.event == .onChange }.contains {
            fails(restriction: $0.restriction, forText: text) == false
        }
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // Apply any blur handlers.
        handlers.filter { $0.event == .blur }.forEach { $0.handler(self) }
        
        // Apply any blur validations.
        return validations.filter { $0.event == .blur }.contains { fails(restriction: $0.restriction) }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType ==  .next {
            form.didTapNextFrom(field: self)
        }
        return true
    }
}
