//
//  Row.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/20/17.
//
//

import UIKit

public class Row: NSObject {
    
    @discardableResult
    public init(in form: Form, constructor: (() -> Void)? = nil) {
        
        constructor?()
    }
}
