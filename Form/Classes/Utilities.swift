//
//  Utilities.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/1/17.
//
//

import UIKit

class FormScrollView: UIScrollView {
    var form: Form!
}

public class FieldLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func assignPreferredFont() {
        font = UIFont.preferredFont(forTextStyle: .body)
    }
}

public class FieldView: UIView {
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Utilities {
    class func constrain(field: Field, withView aView: UIView) {
        
        field.view.addSubview(aView)
        field.view.addConstraint(NSLayoutConstraint(item: aView, attribute: .left, relatedBy: .equal, toItem: field.view, attribute: .left, multiplier: 1, constant: field.padding.left))
        field.view.addConstraint(NSLayoutConstraint(item: field.view, attribute: .right, relatedBy: .equal, toItem: aView, attribute: .right, multiplier: 1, constant: field.padding.right))
        field.view.addConstraint(NSLayoutConstraint(item: field.view, attribute: .bottom, relatedBy: .equal, toItem: aView, attribute: .bottom, multiplier: 1, constant: field.padding.bottom))
        
        if let label = field.label {
            field.view.addSubview(label)
            field.view.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: field.view, attribute: .left, multiplier: 1, constant: field.padding.left))
            field.view.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: field.view, attribute: .top, multiplier: 1, constant: field.padding.top))
            field.view.addConstraint(NSLayoutConstraint(item: field.view, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: field.padding.right))
            field.view.addConstraint(NSLayoutConstraint(item: aView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0))
        } else {
            field.view.addConstraint(NSLayoutConstraint(item: aView, attribute: .top, relatedBy: .equal, toItem: field.view, attribute: .top, multiplier: 1, constant: 0))
        }
    }
}


extension UIView {
    func form_fill(parentView: UIView, withPadding padding: Space) {
        translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(self)
        
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: padding.left))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: padding.top))
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: padding.right))
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: padding.bottom))
    }
}

