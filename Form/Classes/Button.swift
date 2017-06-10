//
//  Button.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/23/17.
//
//

import UIKit

final public class Button: NSObject, Field {
    
    // #MARK - Field
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var value: Any?
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default
    
    public var button: UIButton
    
    var tapCallback: ((Button) -> Void)?
    
    public override init() {
        view = FieldView()
        stackView = UIStackView()
        if let title = title {
            label = FieldLabel()
            label?.text = title
        }
        button = UIButton()
        super.init()
        
        setupStackViewWith(contentView: button)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
    }
    
    @discardableResult
    public func title(_ text: String?) -> Self {
        button.setTitle(text, for: .normal)
        return self
    }
    
    func action(button: UIButton) {
        tapCallback?(self)
    }
    
    public func didChangeContentSizeCategory() {
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }

    
    @discardableResult
    public func style(_ style: ((Button) -> Void)) -> Self {
        style(self)
        return self
    }
}
