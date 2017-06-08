//
//  Separator.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/27/17.
//
//

import UIKit

final public class Separator: UIView {
    
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var attachedTo: InputKey?
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default

    
    @discardableResult
    public required init() {
        
        view = FieldView()
        stackView = UIStackView()
        label = FieldLabel()
        label?.text = title
        label?.textAlignment = .center
        label?.backgroundColor = .yellow
        label?.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        
        super.init(frame: .zero)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let leftSeparatorView = UIView()
        leftSeparatorView.backgroundColor = UIColor.red
        leftSeparatorView.translatesAutoresizingMaskIntoConstraints = true
//        leftSeparatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        stackView.addArrangedSubview(leftSeparatorView)
        leftSeparatorView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        stackView.addArrangedSubview(label!)
        
        let rightSeparatorView = UIView()
        rightSeparatorView.backgroundColor = UIColor.blue
        rightSeparatorView.translatesAutoresizingMaskIntoConstraints = true
//        rightSeparatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        stackView.addArrangedSubview(rightSeparatorView)
        rightSeparatorView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        

        padding.topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: padding.top)
        padding.rightConstraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: stackView, attribute: .right, multiplier: 1, constant: padding.right)
        padding.bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1, constant: padding.bottom)
        padding.leftConstraint = NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: padding.left)
        view.addConstraints([padding.topConstraint, padding.rightConstraint, padding.bottomConstraint, padding.leftConstraint])
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    public func title(_ title: String) -> Self {
        label?.text = title
        return self
    }

}

extension Separator: Field {
    @discardableResult
    public func style(_ style: ((Separator) -> Void)) -> Self {
        style(self)
        return self
    }
}
