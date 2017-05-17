//
//  Slider.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/13/17.
//
//

import UIKit

final public class Slider: NSObject {
    public var form: Form
    public var view: UIView
    public var label: UILabel
    public var slider: UISlider
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default
    public var key: String?
    public var value: Any? {
        return nil
    }
    
    
    @discardableResult
    public init(_ form: Form) {
        self.form = form
        view = UIView()
        label = UILabel()
        slider = UISlider()
        super.init()
        
    
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        view.addSubview(label)
        view.addSubview(slider)
        
        // Label constraints.
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top))
        
        // Slider constraints.
        view.addConstraint(NSLayoutConstraint(item: slider, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: slider, attribute: .right, multiplier: 1, constant: padding.right))
        view.addConstraint(NSLayoutConstraint(item: slider, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: padding.top))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: slider, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
        form.add { self }
        
        slider.addTarget(self, action: #selector(slideAction), for: .valueChanged)
    }
    
    func slideAction(sender: UISlider) {
        print(sender.value)
    }
    
    public func didChangeContentSizeCategory() {
        label.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    @discardableResult
    public func title(_ title: String?) -> Self {
        label.text = title
        return self
    }
}

extension Slider: Field {
    
    @discardableResult
    public func style(_ style: ((Slider) -> Void)) -> Self {
        style(self)
        return self
    }
}
