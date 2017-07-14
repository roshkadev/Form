//
//  Row.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/20/17.
//
//

import UIKit

public class Row: NSObject {
    
    /// The row's containing form.
    var form: Form
    
    /// The horizontal layout containing the row's fields.
    var horizontalStackView = UIStackView()
    
    /// This row's fields
    var fields = [Field]()
    
    /// The row initializer. 
    /// The constructor is just to provide the row instance inside the scope where the fields are initialized.
    @discardableResult
    public init(in form: Form, constructor: ((Row) -> ())? = nil) {
        
        self.form = form
        super.init()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        form.add(row: self)
        constructor?(self)
//        let spaceView = UIView()
//        spaceView.translatesAutoresizingMaskIntoConstraints = false
//        spaceView.backgroundColor = UIColor.green
//        spaceView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
//        horizontalStackView.addArrangedSubview(spaceView)
    }
    
    /// Adds a field to this row.
    @discardableResult
    public func add(field: Field) -> Self {
        field.form = form
        horizontalStackView.addArrangedSubview(field.view)
        fields.append(field)
        return self
    }
    
    /// Adds a view to this row.
    @discardableResult
    public func add(view: UIView) -> Self {
        horizontalStackView.addArrangedSubview(view)
        return self
    }
}
