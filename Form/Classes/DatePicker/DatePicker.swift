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
    case shouldFocus    // Return `false` to disable `Picker` focus. Not applicable to embedded pickers.
    case focus          // The `Picker` gained focus. Not applicable to embedded pickers.
    
    case onChange       // The value of the `Picker` has changed.
    
    case shouldBlur     // Return `false` to disable `Picker` blur. Not applicable to embedded pickers.
    case blur           // The `Picker` lost focus.
    
    case submit         // The containing `Form` received a `FormEvent.submit` event.
}

public enum DatePickerReaction {
    case none
    case last
}

public enum DatePickerPresentationStyle {
    case keyboard
    case embedded
    case dialog
}

final public class DatePicker: NSObject, Field {
    
    /// This field's containing `Form`.
    public var form: Form
    
    /// This field's view.
    public var view: UIView
    
    /// The constraint used to show and hide the field.
    public var bottomLayoutConstraint: NSLayoutConstraint?
    
    /// The underlying text field of this `DatePicker`. nil when embedded is true.
    var textField: UITextField?
    
    /// The underlying picker view of this `Picker`.
    var datePickerInputView: DatePickerInputView
    
    /// The underlying picker view of this `Picker`.
    var datePicker: UIDatePicker {
        return datePickerInputView.datePicker
    }
    
    /// This field's padding.
    public var padding = Space.default
    
    public init(_ form: Form, style: DatePickerPresentationStyle = .keyboard) {
        
        self.form = form
        view = UIView()
        
        datePickerInputView = UINib(nibName: "DatePickerInputView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: nil, options: nil)[0] as! DatePickerInputView
        
        super.init()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .keyboard:
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            //            textField.delegate = self
            textField.inputView = datePickerInputView
            
            textField.form_fill(parentView: view, withPadding: padding)
            textField.backgroundColor = UIColor.red
            
            datePickerInputView.backgroundColor = UIColor.lightGray
            
            //            textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            
            self.textField = textField
        case .embedded:
            datePickerInputView.form_fill(parentView: view, withPadding: padding)
            datePickerInputView.button.isHidden = true
        case .dialog:
            break
        }
        
        form.add { self }
        
    }
    
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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

//extension DatePicker: UITextFieldDelegate {
//    
//    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return validateForEvent(event: .shouldFocus)
//    }
//    
//    public func textFieldDidBeginEditing(_ textField: UITextField) {
//        selectedOption = options.first
//        _ = validateForEvent(event: .focus)
//    }
//    
//    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return validateForEvent(event: .shouldBlur)
//    }
//    
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        _ = validateForEvent(event: .blur)
//    }
//    
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
//    
//    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        return false
//    }
//    
//    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
//    
//}

