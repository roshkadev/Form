//
//  Row.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/20/17.
//
//

import UIKit

public class Row: NSObject {
    
    
    var horizontalStackView: UIStackView
    var form: Form!
    
    @discardableResult
    public init(in form: Form, constructor: ((Row) -> ())? = nil) {
        horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        
        super.init()
        
        form.add(row: self)
        
        constructor?(self)
    }
    
    @discardableResult
    public func add(field: Field) -> Self {
        horizontalStackView.addArrangedSubview(field.view)
        return self
    }
}
