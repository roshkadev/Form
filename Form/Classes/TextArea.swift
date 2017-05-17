//
//  TextArea.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit

final public class TextArea: NSObject {
    public var form: Form
    public var view: UIView
    public var key: String?
    public var value: Any? {
        return nil
    }
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default
    var label: UILabel
    var textView: UITextView
    
    
    public init(_ form: Form) {
        
        self.form = form
        view = UIView()
        label = UILabel()
        textView = UITextView()
        
        super.init()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        textView.text = "Hello"
        textView.isScrollEnabled = false
        
        view.addSubview(label)
        view.addSubview(textView)
        
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: padding.right))
        
        
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: textView, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
        
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1 / UIScreen.main.scale
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        
        view.backgroundColor = UIColor.brown
        
        
//        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
    
        
        form.add { self }
    }
    
    @discardableResult
    public func title(_ title: String?) -> Self {
        label.text = title
        return self
    }
}

extension TextArea: Field {
    
    public var canBecomeFirstResponder: Bool {
        return true
    }
    
    public func becomeFirstResponder(){
        textView.becomeFirstResponder()
    }
    
    public func resignFirstResponder(){
        textView.becomeFirstResponder()
    }
    
    public func style(_ style: ((TextArea) -> Void)) -> Self {
        style(self)
        return self
    }
    
    public func didChangeContentSizeCategory() {
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

extension TextArea: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        form.assign(activeField: self)
        return true
    }
}
