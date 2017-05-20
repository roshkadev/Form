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
    public var view: FieldView
    public var label: FieldLabel?
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
    public init(_ form: Form, title: String? = nil) {
        self.form = form
        view = FieldView()
        label = FieldLabel()
        slider = UISlider()
        super.init()
    
        Utilities.constrain(field: self, withView: slider)
        
        form.add { self }
        
        slider.addTarget(self, action: #selector(slideAction), for: .valueChanged)
    }
    
    func slideAction(sender: UISlider) {
        print(sender.value)
    }
    
    public func didChangeContentSizeCategory() {
        
    }
}

extension Slider: Field {
    
    @discardableResult
    public func style(_ style: ((Slider) -> Void)) -> Self {
        style(self)
        return self
    }
}
