//
//  InputAccessoryView.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/29/17.
//
//

import UIKit

class NextInputAccessoryView: UIView {
    
    var requiresUpdateConstraints = true
    
    var nextButton: UIButton
    
    init() {
        nextButton = UIButton()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor.red
        addSubview(nextButton)
        
        addConstraint(NSLayoutConstraint(item: nextButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nextButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nextButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        setNeedsLayout()
        layoutIfNeeded()
        print(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
