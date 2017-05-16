//
//  PickerInputView.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/30/17.
//
//

import UIKit

class PickerInputView: UIView {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
    var buttonCallback: (() -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.isHidden = true
        
//        shadowView.layer.shadowColor = UIColor.gray.cgColor
//        shadowView.layer.shadowRadius = 1
//        shadowView.layer.shadowOpacity = 1
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
    }

    @IBAction func buttonAction(_ sender: Any) {
        buttonCallback()
    }
}
