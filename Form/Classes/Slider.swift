//
//  Slider.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/13/17.
//
//

import UIKit

final public class Slider: NSObject {
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var stackView: UIStackView
    public var title: String?
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
    public override init() {
        view = FieldView()
        stackView = UIStackView()
        label = FieldLabel()
        slider = UISlider()
        super.init()
        
        Utilities.constrain(field: self, withView: slider)
        
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
