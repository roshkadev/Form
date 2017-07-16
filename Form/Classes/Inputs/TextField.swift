//
//  UITextField.swift
//  Pods
//
//  Created by Paul Von Schrottky on 7/16/17.
//
//

import UIKit

public class TextField: UITextField {
    
    var leftViewInset: CGFloat?
    var rightViewInset: CGFloat?
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let size = leftView?.sizeThatFits(bounds.size) else { return CGRect.zero }
        let left = leftViewInset ?? 0
        let rect = CGRect(x: left, y: (bounds.height - size.height) / 2, width: size.width, height: size.height)
        return rect
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let size = rightView?.sizeThatFits(bounds.size) else { return CGRect.zero }
        let right = rightViewInset ?? 0
        let rect = CGRect(x: bounds.width - size.width - right, y: (bounds.height - size.height) / 2, width: size.width, height: size.height)
        return rect
    }
    


}
