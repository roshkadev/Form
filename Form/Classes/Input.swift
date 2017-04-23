//
//  Input.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit

public class Input: NSObject, Field {
    
    public var view: UIView
    public var space = Space.default
    var textField: UITextField
    
    public var events = [Event]()
    
    override public init() {
        
        
        view = UIView()
        textField = UITextField()
        
        super.init()
        
        view.backgroundColor = UIColor.orange
        textField.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        
        let autolayoutViews: [String: Any] = [
            "textField": textField
        ]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textField]-|", options: [], metrics: nil, views: autolayoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textField]-|", options: [], metrics: nil, views: autolayoutViews))
        
    }
    
    deinit {
        print("Input deinitialized")
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
    
    public func isValid() -> (result: Bool, message: String?) {
//        return true
//        if let validator = validator {
//            switch validator {
//            case .isEmpty(let message):
//                let result = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true
//                return (result, message)
//            }
//        }
        return (true, nil)
    }
}

extension Input: Restrict {
    
    public func blur(_ restriction: Restriction) -> Self {
        events.append(Event.blur(restriction, .none))
        return self
    }
    
    public func live(_ restriction: Restriction) -> Self {
        events.append(Event.live(restriction, .none))
        return self
    }
    
    public func submit(_ restriction: Restriction) -> Self {
        events.append(Event.submit(restriction, .none))
        
        return self
    }
    
    
    public func blur(_ restriction: Restriction, _ reaction: Reaction) -> Self {
        events.append(Event.blur(restriction, reaction))
        return self
    }
    
    public func live(_ restriction: Restriction, _ reaction: Reaction) -> Self {
        events.append(Event.live(restriction, reaction))
        return self
    }
    
    public func submit(_ restriction: Restriction, _ reaction: Reaction) -> Self {
        events.append(Event.submit(restriction, reaction))
        return self
    }

    

}

extension Input: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text ?? "") as NSString
        let newText = text.replacingCharacters(in: range, with: string)
        let length = newText.characters.count
        
        return !events.reduce(false, { result, event in
            switch event {
            case .live(.some, _):
                return result || newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case .live(.max(let max), let reaction):
                
                let res = result || length > max
                
                if res {
                
                    switch reaction {
                    case .shake:
                        textField.shake()
                    default:
                        break
                    }
                }
                return res
            case .live(.min(let min), _):
                return result || length < min
            case .live(.range(let min, let max), _):
                return result || (length > max || length < min)
            case .live(.currency(let locale), _):
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.maximumFractionDigits = 0
                numberFormatter.locale = locale
                numberFormatter.currencySymbol = ""
                var raw = newText.replacingOccurrences(of: numberFormatter.decimalSeparator, with: ".")
                raw = raw.replacingOccurrences(of: numberFormatter.groupingSeparator, with: "")
                let integer = Double(raw)!
                let number = NSNumber(value: integer)
                let string = numberFormatter.string(from: number)
                textField.text = string
                return false
            default:
                return result
            }
        })
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let text = (textField.text ?? "") as NSString
        let length = text.length
        
        return !events.reduce(false, { result, event in
            switch event {
            case .blur(.some, _):
                return result || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case .blur(.max(let max), _):
                return result || length > max
            case .blur(.min(let min), _):
                return result || length < min
            case .blur(.range(let min, let max), _):
                return result || (length > max || length < min)
            default:
                return result
            }
        })
    }
}
