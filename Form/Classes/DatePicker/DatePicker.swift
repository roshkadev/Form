//
//  DatePicker.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/30/17.
//
//

import UIKit


/// A `DatePickerEvent` associated with a `DatePicker`.
public enum DatePickerEvent {
    case shouldFocus    // Return `false` to disable `DatePicker` focus. Not applicable to embedded pickers.
    case focus          // The `DatePicker` gained focus. Not applicable to embedded pickers.
    
    case onChange       // The value of the `DatePicker` has changed (comes to rest).
    
    case shouldBlur     // Return `false` to disable `DatePicker` blur. Not applicable to embedded pickers.
    case blur           // The `DatePicker` lost focus. Not applicable to embedded pickers.
    
    case submit         // The containing `Form` received a `FormEvent.submit` event.
}

public enum DatePickerRestriction {
    case none
    case weekday
    case weekend
}

/// A `DatePickerReaction` is the response of a `DatePicker` to a `DatePickerReaction`.
public enum DatePickerReaction {
    case none
    case lastSelection
    case previous
    case next
    case shake
    case alert(String)
    case popup(String)
    case submit(PickerRestriction)
}

public enum DatePickerPresentationStyle {
    case keyboard
    case embedded
    case dialog
}


public typealias DatePickerValidation = (event: DatePickerEvent, restriction: DatePickerRestriction, reaction: DatePickerReaction)
public typealias DatePickerValidationResult = (isValid: Bool, reaction: DatePickerReaction)


public class DatePicker: NSObject {
    
    /// This field's containing `Form`.
    public var form: Form
    
    /// This field's view.
    public var view: UIView
    
    /// The constraint used to show and hide the field.
    public var bottomLayoutConstraint: NSLayoutConstraint?
    
    /// The underlying text field of this `DatePicker`. nil when embedded is true.
    var textField: UITextField?
    
    /// The underlying picker view of this `DatePicker`.
    var datePickerInputView: DatePickerInputView
    
    /// The underlying picker view of this `DatePicker`.
    var datePicker: UIDatePicker {
        return datePickerInputView.datePicker
    }
    
    /// This field's padding.
    public var padding = Space.default
    
    
    /// 
    var style: DatePickerPresentationStyle
    
    /// Storage for this date picker's validations.
    public var validations = [DatePickerValidation]()
    
    /// `DatePickerEvent` handlers.
    public var handlers = [(event: DatePickerEvent, handler: ((DatePicker) -> Void))]()
    
    fileprivate var lastDate: Date?
    
    public init(_ form: Form, style: DatePickerPresentationStyle = .keyboard) {
        
        self.form = form
        self.style = style
        view = UIView()
        
        datePickerInputView = UINib(nibName: "DatePickerInputView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: nil, options: nil)[0] as! DatePickerInputView
        datePickerInputView.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        
        super.init()
        
        datePickerInputView.buttonCallback = { form.didTapNextFrom(field: self) }
        datePicker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .keyboard:
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.inputView = datePickerInputView
            textField.form_fill(parentView: view, withPadding: padding)
            textField.backgroundColor = .red
            datePickerInputView.backgroundColor = .lightGray
            self.textField = textField
        case .embedded:
            datePickerInputView.form_fill(parentView: view, withPadding: padding)
            datePickerInputView.button.isHidden = true
        case .dialog:
            break
        }
        
        form.add { self }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func valueChanged(sender: UIDatePicker) {
        let isValid = validateForEvent(event: DatePickerEvent.onChange)
        if isValid {
            lastDate = sender.date
        }
        
    }
}

extension DatePicker: Field {
    public func style(_ style: ((Field) -> Void)) -> Self {
        style(self)
        return self
    }
    
    public var canBecomeFirstResponder: Bool {
        return style == .keyboard
    }
    
    public func becomeFirstResponder() {
        if style == .keyboard { textField?.becomeFirstResponder() }
    }
}

/// Public interface for validating an instance of `DatePicker`.
extension DatePicker {
    
    public func validateForEvent(event: DatePickerEvent) -> Bool {
        
        // Apply any event handlers.
        handlers.filter { $0.event == event }.forEach { $0.handler(self) }
        
        let selectedDate = datePickerInputView.datePicker.date
        let isDateInWeekend = Calendar.current.isDateInWeekend(selectedDate)
        
        let failingValidation: DatePickerValidationResult? = validations.filter {
            $0.event == event   // Only get events of the specified type.
        }.map {
            switch $0 {
            case (_, .weekday, let reaction):
                return (isDateInWeekend, reaction)
            case (_, .weekend, let reaction):
                return (!isDateInWeekend, reaction)
            default:
                return (true, .none)
            }
        }.filter { $0.isValid == false }.first
        
        if let failingValidation = failingValidation {
            switch failingValidation.reaction {
            case .shake:
                view.shake()
            case .alert(let message):
                print(message)
            default:
                break
            }
            
            if let lastDate = lastDate {
                datePicker.setDate(lastDate, animated: true)
            }
            
            return false
        }
        
        return true
    }
    
    public func bind(_ event: DatePickerEvent, _ restriction: DatePickerRestriction, _ reaction: DatePickerReaction) -> Self {
        validations.append(DatePickerValidation(event, restriction, reaction))
        return self
    }
    
    public func validateForEvent(event: PickerEvent) -> Bool {
        return true
    }
}


/// Public interface for configuring an instance of `DatePicker`.
extension DatePicker {
    
    public func placeholder(_ placeholder: String?) -> Self {
        textField?.placeholder = placeholder
        return self
    }
    
    public func earliest(date: Date) -> Self {
        datePicker.minimumDate = date
        return self
    }
    
    public func latest(date: Date) -> Self {
        datePicker.maximumDate = date
        return self
    }
}

