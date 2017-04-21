//
//  Input.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit

public class Input: NSObject, FormItem {
    
    public var view: UIView
    var textField: UITextField
    
    public override init() {
        view = UIView()
        view.backgroundColor = UIColor.orange
        textField = UITextField()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        
        let autolayoutViews: [String: Any] = [
            "textField": textField
        ]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textField]-|", options: [], metrics: nil, views: autolayoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textField]-|", options: [], metrics: nil, views: autolayoutViews))
        
    }

}
