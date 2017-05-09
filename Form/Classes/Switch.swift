//
//  Switch.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/8/17.
//
//

import UIKit

final public class Switch: NSObject {
    public var form: Form
    public var view: UIView
    public var label: UILabel
    public var `switch`: UISwitch
    public var topLayoutConstraint: NSLayoutConstraint?
    public var padding = Space.default
    public var key: String?
    public var value: Any? {
        return `switch`.isOn
    }
    
    private var onToggleCallback: ((Bool) -> ())?
    private var toggledFieldGroups = [[Field]]()
    
    @discardableResult
    public init(_ form: Form) {
        self.form = form
        view = UIView()
        label = UILabel()
        `switch` = UISwitch()
        super.init()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        `switch`.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        view.addSubview(label)
        view.addSubview(`switch`)
        
        // Horizontal constraints.
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: `switch`, attribute: .left, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: Space.left.space))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: `switch`, attribute: .right, multiplier: 1, constant: Space.right.space))
        
        // Vertical constraints.
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: `switch`, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: label, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: `switch`, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: `switch`, attribute: .top, multiplier: 1, constant: 0))
        
        form.add { self }
        
        `switch`.addTarget(self, action: #selector(toggleAction), for: .valueChanged)
    }
    
    @discardableResult
    public func title(_ title: String?) -> Self {
        label.text = title
        return self
    }
    
    @discardableResult
    public func onToggle(_ callback: @escaping (Bool) -> ()) -> Self {
        onToggleCallback = callback
        return self
    }
    
    @discardableResult
    public func toggles(_ addFields: (Void) -> Void) -> Self {
        let fieldViewsBefore = Set(form.fields.map { $0.view })
        addFields()
        let fieldViewsAfter = Set(form.fields.map { $0.view })
        let newFields = fieldViewsBefore.symmetricDifference(fieldViewsAfter).map { fieldView in
            return form.fields.filter { $0.view == fieldView }.first!
        }
        toggledFieldGroups.append(newFields)
        print("newFields:", newFields)
        
        
        return self
    }
    
    func toggleAction(sender: UISwitch) {
        toggledFieldGroups.forEach {
            $0.forEach {
                $0.toggleVisibility()
            }
        }
    }
}

extension Switch: Field {
    
    @discardableResult
    public func style(_ style: ((Switch) -> Void)) -> Self {
        style(self)
        return self
    }
}
