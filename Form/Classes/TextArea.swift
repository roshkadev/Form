//
//  TextArea.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit

final public class TextArea: NSObject {
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var value: Any? {
        return nil
    }
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var margin = [Margin]()
    
    var textView: UITextView
    
    public var formBindings = [(event: FormEvent, field: Field, handler: ((Field) -> Void))]()
    
    
    override public init() {
    
        view = FieldView()
        stackView = UIStackView()
        if let title = title {
            label = FieldLabel()
            label?.text = title
        }
        textView = UITextView()
        
        super.init()
        
        textView.delegate = self
        textView.text = "Hello"
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1 / UIScreen.main.scale
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        
        Utilities.constrain(field: self, withView: textView)
        

        
        view.backgroundColor = UIColor.brown
        
        
//        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
    
        
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
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }

}

extension TextArea: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        form.assign(activeField: self)
        return true
    }
}
