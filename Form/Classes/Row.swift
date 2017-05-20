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
    
    @discardableResult
    public init(in form: Form, constructor: (() -> Void)? = nil) {
        horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 0
        
        constructor?()
    }
}
