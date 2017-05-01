//
//  Utilities.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/1/17.
//
//

import UIKit


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
