//
//  Picker.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/27/17.
//
//

import UIKit


/// A `PickerEvent` associated with a `Picker`.
public enum PickerEvent {
    
    case shouldFocus    // Return `false` to disable `Picker` focus.
    case focus          // The `Picker` gained focus.
    
    case onChange       // The value of the `Picker` has changed.
    
    case shouldBlur     // Return `false` to disable `Picker` blur.
    case blur           // The `Picker` lost focus.
    
    case submit         // The containing `Form` received a `FormEvent.submit` event.
}

/// A restiction associated with a `Picker`
public enum PickerRestriction {
    case empty
    case nonempty
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


/// `OnPickerValidationEvent` is a protocol used to bind a `PickerRestriction` to a `PickerEvent` on a `Picker`.
public protocol OnPickerValidationEvent: class, Field {
    
    var validations: [PickerValidation] { get set }
    func bind(_ event: PickerEvent, _ restriction: PickerRestriction, _ reaction: PickerReaction) -> Self
    func validateForEvent(event: PickerEvent) -> Bool
}

/// Provide a default implementation of the `OnPickerValidationEvent`.
extension OnPickerValidationEvent {
    
    public func bind(_ event: PickerEvent, _ restriction: PickerRestriction, _ reaction: PickerReaction) -> Self {
        validations.append(PickerValidation(event, restriction, reaction))
        return self
    }
}

/// `OnHandlePickerEvent` is a protocol used to bind an event handler to an `PickerEvent`.
public protocol OnHandlePickerEvent: class, Field {
    var handlers: [(event: PickerEvent, handler: ((Picker) -> Void))] { get set }
    func bind(_ event: PickerEvent, handler: @escaping ((Picker) -> Void)) -> Self
}

/// A `PickerOption`
public struct PickerOption {
    var title: String
    var value: String
    
    public init(_ title: String, _ value: String? = nil) {
        self.title = title
        self.value = value ?? title
    }
}

extension PickerOption: Equatable {
    public static func ==(lhs: PickerOption, rhs: PickerOption) -> Bool {
        return lhs.value == rhs.value && lhs.title == rhs.title
    }
}

final public class Picker: NSObject, Field {
    
    /// This field's containing `Form`.
    public var form: Form
    
    /// This field's view.
    public var view: UIView
    
    /// The underlying text field of this `Picker`. Is nil when `Picker` is embedded.
    var textField: UITextField?
    
    /// The underlying picker view of this `Picker`.
    var pickerView: UIPickerView {
        return pickerInputView.pickerView
    }
    
    /// The underlying picker view of this `Picker`.
    var pickerInputView: PickerInputView
    
    /// This field's padding.
    public var padding = Space.default
    
    /// Storage for this field's validations.
    public var validations = [PickerValidation]()
    
    /// `PickerEvent` handlers.
    public var handlers = [(event: PickerEvent, handler: ((Picker) -> Void))]()
    
    /// A `Picker` contains one or more `PickerOption` objects.
    var options = [PickerOption]()

    var disabledRowRanges = [CountableClosedRange<Int>]()
    var selectedOption: PickerOption?
    var defaultIndex: Int?
    
    public init(_ form: Form, embedded: Bool = false) {
        
        self.form = form
        view = UIView()
        
        pickerInputView = UINib(nibName: "PickerInputView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: nil, options: nil)[0] as! PickerInputView
        
        super.init()
    
        pickerView.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        if embedded == false {
            
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.delegate = self
            textField.inputView = pickerInputView
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(textField)
            
            view.addConstraint(NSLayoutConstraint(item: textField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
            view.addConstraint(NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: textField, attribute: .right, multiplier: 1, constant: padding.right))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: padding.bottom))
            
            pickerInputView.backgroundColor = UIColor.lightGray
            
            textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            
            self.textField = textField
        } else {
            pickerInputView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pickerInputView)
            
            view.addConstraint(NSLayoutConstraint(item: pickerInputView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
            view.addConstraint(NSLayoutConstraint(item: pickerInputView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: pickerInputView, attribute: .right, multiplier: 1, constant: padding.right))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: pickerInputView, attribute: .bottom, multiplier: 1, constant: padding.bottom))
            pickerInputView.button.isHidden = true
        }
        
        form.add { self }
    }
    
    public func options(_ options: [PickerOption]) -> Self {
        self.options = options
        return self
    }
    
    public func disableRowsIn(range: CountableClosedRange<Int>) -> Self {
        disabledRowRanges.append(range)
        return self
    }
    
    public func disable(row: Int) -> Self {
        let range = row ... row
        _ = disableRowsIn(range: range)
        return self
    }
    
    public func disableFirstRow() -> Self {
        let range = 0 ... 0
        _ = disableRowsIn(range: range)
        return self
    }
    
    
    
    public var text: String? {
        return textField?.text
    }
    
    public func defaultIndex(_ index: Int) -> Self {
        defaultIndex = index
        return self
    }
    
    public func placeholder(_ placeholder: String?) -> Self {
        textField?.placeholder = placeholder
        return self
    }
    
    func isDisabled(row: Int) -> Bool {
        let isRowDisabled = disabledRowRanges.filter { range in
            range.contains(row)
        }.first != nil
        return isRowDisabled
    }
    
    deinit {
        print("Picker deinitialized")
    }

}

// #MARK: Construction.
extension Picker {

    
    func action(button: UIButton) {
        print("ewfewfewfwefewfweffwe")
    }
}


// #MARK: Target actions.
extension Picker {
    
    /// On-Change event handler.
    func editingChanged(textField: UITextField) {
        handlers.filter {
            $0.event == .onChange
        }.forEach { $0.handler(self) }
    }
}

extension Picker: OnHandlePickerEvent {
    public func bind(_ event: PickerEvent, handler: @escaping ((Picker) -> Void)) -> Self {
        handlers.append((event, handler))
        return self
    }
}

extension Picker: OnPickerValidationEvent {
    public func validateForEvent(event: PickerEvent) -> Bool {
        
        // Apply any event handlers.
        handlers.filter { $0.event == event }.forEach { $0.handler(self) }
        
        let isEmpty = (textField?.text ?? "").isEmpty
        let selectedRow = pickerView.selectedRow(inComponent: 0)    // TO-DO support multiple components
        
        let failingValidation: PickerValidationResult? = validations.filter {
            $0.event == event   // Only get events of the specified type.
        }.map {
            switch $0 {
            case (_, .empty, let reaction):
                return (isEmpty, reaction)
            case (_, .nonempty, let reaction):
                return (!isEmpty, reaction)
            default:
                return (true, .none)
            }
        }.filter { $0.isValid == false }.first
        
        if let failingValidation = failingValidation {
            switch failingValidation.reaction {
            case .shake:
                textField?.shake()
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
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].title
    }
}

extension Picker: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        var color = UIColor.black
        if isDisabled(row: row) {
            color = .gray
        }
        
        return NSAttributedString(string: options[row].title, attributes: [
            NSForegroundColorAttributeName: color,
        ])
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isDisabled(row: row) {
            
            if let previouslySelectedOption = selectedOption, let previouslySelectedRowIndex = options.index(of: previouslySelectedOption) {
                pickerView.selectRow(previouslySelectedRowIndex, inComponent: component, animated: true)
            } else {
                
            }
        } else {
            textField?.text = options[row].title
            _ = validateForEvent(event: .onChange)
            selectedOption = options[row]
        }
    }
}

extension Picker: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return validateForEvent(event: .shouldFocus)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedOption = options.first
        _ = validateForEvent(event: .focus)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return validateForEvent(event: .shouldBlur)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        _ = validateForEvent(event: .blur)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

}

