//
//  DatePickerInputView.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/1/17.
//
//

import UIKit

class DatePickerInputView: UIView {
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var button: UIButton!
    
    var buttonCallback: (() -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
    }


    @IBAction func buttonAction(sender: AnyObject) {
        buttonCallback()
    }
}
