//
//  Form.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit
import ObjectiveC

public protocol Field {
    
    var form: Form { get set }
    var view: UIView { get set }
    var padding: Space { get set }
    func style(_ style: ((Field) -> Void)) -> Self
}

extension Field {
    public func style(_ style: ((Field) -> Void)) -> Self {
        style(self)
        return self
    }
}


class FormScrollView: UIScrollView {
    var form: Form!
}

public class Form: NSObject {
    
    var scrollView: FormScrollView
    var containingView: UIView
    var fields: [Field]
    
    @discardableResult
    public init(in viewController: UIViewController, constructor: ((Form) -> Void)? = nil) {
        
        fields = []
        containingView = viewController.view
        scrollView = FormScrollView()
        
        super.init()
        
        scrollView.form = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(scrollView)
        let autolayoutViews: [String: Any] = [
            "scrollView": scrollView
        ]
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        
        constructor?(self)
    }
    
    @discardableResult
    public func add(_ margin: Space = .default, _ add: ((Void) -> Field?)) -> Self {
        
        guard var field = add() else { return self }
        field.form = self
        
        scrollView.addSubview(field.view)
        

        if let lastField = fields.last {
            containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .top, relatedBy: .equal, toItem: lastField.view, attribute: .bottom, multiplier: 1, constant: margin.top))
        } else {
            containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: margin.top))
        }
        
        containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1, constant: margin.left))
        containingView.addConstraint(NSLayoutConstraint(item: containingView, attribute: .right, relatedBy: .equal, toItem: field.view, attribute: .right, multiplier: 1, constant: margin.right))
        
        fields.append(field)
        
        return self
    }
    
    @discardableResult
    public func navigation(_ navigation: Bool) -> Self {
        let inputs = fields.flatMap { $0 as? Input }
        inputs.forEach {
            if $0.textField.keyboardType == .numberPad || $0.textField.keyboardType == .decimalPad || $0.textField.keyboardType == .phonePad {
                $0.textField.inputAccessoryView = NextInputAccessoryView()
            }
        }
        return self
    }
    
    
    deinit {
        print("Form deinitialized")
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
