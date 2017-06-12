//
//  Stepper.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/14/17.
//
//

import UIKit

final public class Stepper: NSObject {
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var contentView: UIView!
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var stepper: UIStepper
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default
    public var key: String?
    public var value: Any? {
        return nil
    }
    public var formBindings = [(event: FormEvent, field: Field, handler: ((Field) -> Void))]()
    
    
    @discardableResult
    override public init() {
        view = FieldView()
        stackView = UIStackView()
        if let title = title {
            label = FieldLabel()
            label?.text = title
        }
        stepper = UIStepper()
        super.init()
        
        Utilities.constrain(field: self, withView: stepper)
        
        stepper.addTarget(self, action: #selector(stepAction), for: .valueChanged)
    }
    
    func stepAction(sender: UIStepper) {
        print(sender.value)
    }
}

extension Stepper: Field {
    
    @discardableResult
    public func style(_ style: ((Stepper) -> Void)) -> Self {
        style(self)
        return self
    }

}
