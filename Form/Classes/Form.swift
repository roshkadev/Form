//
//  Form.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit
import ObjectiveC

public protocol Restrict {
    var events: [Event] { get set }
    func live(_ restriction: Restriction) -> Self
    func blur(_ restriction: Restriction) -> Self
    func submit(_ restriction: Restriction) -> Self
    
    func live(_ restriction: Restriction, _ reaction: Reaction) -> Self
    func blur(_ restriction: Restriction, _ reaction: Reaction) -> Self
    func submit(_ restriction: Restriction, _ reaction: Reaction) -> Self
}

public protocol Field {
    var view: UIView { get set }
    var space: Space { get set }
    func isValid() -> (result: Bool, message: String?)
}

public enum Event {
    case live(Restriction, Reaction)
    case blur(Restriction, Reaction)
    case submit(Restriction, Reaction)
}

public enum Reaction {
    case none
    case outline
    case highlight
    case shake
    case alert(String)
    case popup(String)
    case submit(Restriction)
}


public enum Restriction {
    case none
    case some
    case max(Int)
    case min(Int)
    case range(Int, Int)
    case regex(String)
    case email
    case url
    case currency(Locale)
}

class FormScrollView: UIScrollView {
    var form: Form!
}

public class Form: NSObject {
    
    var scrollView: FormScrollView
    var containingView: UIView
    var fields: [Field]
    
    @discardableResult
    public init(in viewController: UIViewController) {
        
        fields = []
        containingView = viewController.view
        scrollView = FormScrollView()
        
        super.init()
        
        scrollView.form = self
        scrollView.backgroundColor = UIColor.green
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(scrollView)
        let autolayoutViews: [String: Any] = [
            "scrollView": scrollView
        ]
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        
    }
    
    deinit {
        print("Form deinitialized")
    }
    
    @discardableResult
    public func add(_ space: Space = .default, _ add: ((Void) -> Field?)) -> Self {
        
        guard var field = add() else { return self }
        field.space = space
        
        scrollView.addSubview(field.view)
        

        if let lastField = fields.last {
            containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .top, relatedBy: .equal, toItem: lastField.view, attribute: .bottom, multiplier: 1, constant: space.top))
        } else {
            containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: space.top))
        }
        
        containingView.addConstraint(NSLayoutConstraint(item: field.view, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1, constant: space.left))
        containingView.addConstraint(NSLayoutConstraint(item: containingView, attribute: .right, relatedBy: .equal, toItem: field.view, attribute: .right, multiplier: 1, constant: space.right))
        
        fields.append(field)
        
        return self
    }

    public func validate(_ validator: ((Bool) -> Void)) -> Self {
        let isValid = fields.reduce(true) {
            $0 || $1.isValid().result
        }
        validator(isValid)
        return self
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
