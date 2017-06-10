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
    
    let leftView: UIView!
    let rightView: UIView!
    
    public var separatorColor = UIColor.lightGray {
        didSet {
            leftView.backgroundColor = separatorColor
            rightView.backgroundColor = separatorColor
        }
    }

    
    @discardableResult
    public required init() {
        
        view = FieldView()
        stackView = UIStackView()
        label = FieldLabel()
        label?.text = title
        label?.textAlignment = .center
        label?.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        
        leftView = UIView()
        rightView = UIView()
        
        super.init(frame: .zero)
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let leftSeparatorView = UIView()
        leftSeparatorView.translatesAutoresizingMaskIntoConstraints = true
        stackView.addArrangedSubview(leftSeparatorView)
        
        leftView.backgroundColor = separatorColor
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftSeparatorView.addSubview(leftView)
        leftView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        leftSeparatorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftView]|", options: [], metrics: nil, views: ["leftView": leftView]))
        leftSeparatorView.addConstraint(NSLayoutConstraint(item: leftView, attribute: .centerY, relatedBy: .equal, toItem: leftSeparatorView, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        stackView.addArrangedSubview(label!)
        
        let rightSeparatorView = UIView()
        rightSeparatorView.translatesAutoresizingMaskIntoConstraints = true
        stackView.addArrangedSubview(rightSeparatorView)
        
        rightView.backgroundColor = separatorColor
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightSeparatorView.addSubview(rightView)
        rightView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        rightSeparatorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[rightView]|", options: [], metrics: nil, views: ["rightView": rightView]))
        rightSeparatorView.addConstraint(NSLayoutConstraint(item: rightView, attribute: .centerY, relatedBy: .equal, toItem: rightSeparatorView, attribute: .centerY, multiplier: 1, constant: 0))
        
        leftSeparatorView.widthAnchor.constraint(equalTo: rightSeparatorView.widthAnchor).isActive = true

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
