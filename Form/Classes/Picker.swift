//
//  Picker.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/27/17.
//
//

import UIKit


/// An `Event` associated with a `Picker`.
public enum PickerEvent {
    case focus
    case change
    case blur
    case submit
}

/// An tense associated with a `PickerEvent`.
public enum PickerTense {
    case should
    case will
    case on
    case did
}

/// A restiction associated with a `Picker`
public enum PickerRestriction {
    case empty
    case nonempty
    case disableRow(Int)
    case disableRange(Int, Int)
}

/// A `Reaction` is the response by a `Field` to a `Restriction`
public enum PickerReaction {
    case none
    case previous
    case next
    case last
    case shake
    case alert(String)
    case popup(String)
    case submit(Restriction)
}

public typealias PickerValidation = (event: PickerEvent, restriction: PickerRestriction, reaction: PickerReaction)
public typealias PickerValidationResult = (isValid: Bool, reaction: PickerReaction)


/// `OnPickerValidationEvent` is a protocol used to bind a `Restriction` to a `Event` on a `Picker`.
public protocol OnPickerValidationEvent: class, Field {
    
    var validations: [PickerValidation] { get set }
    func on(_ event: PickerEvent, _ restriction: PickerRestriction) -> Self
    func on(_ event: PickerEvent, _ restriction: PickerRestriction, _ reaction: PickerReaction) -> Self
    func validateForEvent(event: Event) -> Bool
}

/// Provide a default implementation of the `OnPickerValidationEvent`.
extension OnPickerValidationEvent {
    
    public func on(_ event: PickerEvent, _ restriction: PickerRestriction) -> Self {
        validations.append(PickerValidation(event, restriction, .next))
        return self
    }
    
    public func on(_ event: PickerEvent, _ restriction: PickerRestriction, _ reaction: PickerReaction) -> Self {
        validations.append(PickerValidation(event, restriction, reaction))
        return self
    }
}

/// `OnHandlePickerEvent` is a protocol used to bind an event handler to an `Event`.
public protocol OnHandlePickerEvent: class, Field {
    var handlers: [(event: PickerEvent, handler: ((Picker) -> Void))] { get set }
    func on(_ event: PickerEvent, handler: @escaping ((Picker) -> Void)) -> Self
}



final public class Picker: NSObject, Field {
    
    public var form: Form
    public var view: UIView
    public var padding = Space.default
    var textField: UITextField
    var pickerView: UIPickerView
    
    public var validations = [PickerValidation]()
    public var handlers = [(event: PickerEvent, handler: ((Picker) -> Void))]()
    
    var options = [Any]()
    var constructor: ((Int, Any) -> Void)?
    var defaultIndex: Int?
    
    public init(_ form: Form) {
        
        self.form = form
        view = UIView()
        textField = UITextField()
        pickerView = UIPickerView()
        
        super.init()
        
        textField.delegate = self
        textField.inputView = pickerView
        
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
        print("Picker deinitialized")
    }
    
    public func options(_ options: [Any], constructor: ((Int, Any) -> Void)? = nil) -> Self {
        self.options = options
        self.constructor = constructor
        return self
    }
    
    public var text: String? {
        return textField.text
    }
    
    public func defaultIndex(_ index: Int) -> Self {
        defaultIndex = index
        return self
    }
    
    public func placeholder(_ placeholder: String?) -> Self {
        textField.placeholder = placeholder
        return self
    }
    

}

extension Picker: OnHandlePickerEvent {

    public func on(_ event: PickerEvent, handler: @escaping ((Picker) -> Void)) -> Self {
        handlers.append((event, handler))
        return self
    }
}

extension Picker: OnPickerValidationEvent {
    public func validateForEvent(event: PickerEvent) -> Bool {
        
        let isEmpty = (textField.text ?? "").isEmpty
        let selectedRow = pickerView.selectedRow(inComponent: 0)    // TO-DO support multiple components
        
        let failingValidation: PickerValidationResult? = validations.map {
            switch $0 {
            case (event, .empty, let reaction):
                return (isEmpty, reaction)
            case (event, .nonempty, let reaction):
                return (!isEmpty, reaction)
            case (event, .disableRow(let disabledRow), let reaction):
                return (selectedRow != disabledRow, reaction)
            case (event, .disableRange(let min, let max), let reaction):
                return (selectedRow >= min && selectedRow <= max, reaction)
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

extension Picker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return options.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
}

extension Picker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _ = validateForEvent(event: .change)
    }
}

extension Picker: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Apply any blur validations.
        return validateForEvent(event: .blur)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // Apply any blur callbacks.
        handlers.filter { $0.event == .blur }.forEach { $0.handler(self) }
        
        // Apply any blur validations.
        return validateForEvent(event: .blur)
    }
}

