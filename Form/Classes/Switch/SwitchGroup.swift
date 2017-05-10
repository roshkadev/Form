//
//  SwitchGroup.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/9/17.
//
//

import UIKit

final public class SwitchGroup: NSObject {
    
//    let switches: [Switch]
    
    public init(_ form: Form, _ addSwitches: (Void) -> ()) {
        let fieldViewsBefore = Set(form.fields.map { $0.view })
        addSwitches()
        let fieldViewsAfter = Set(form.fields.map { $0.view })
        let switches = fieldViewsBefore.symmetricDifference(fieldViewsAfter).map { fieldView in
            return form.fields.filter { $0.view == fieldView }.first as? Switch
        }.flatMap { $0 }
        
        switches.forEach { aSwitch in
            aSwitch.onToggle { isOn in
                let otherSwitches = Set(switches).subtracting(Set([aSwitch]))
                otherSwitches.forEach {
                    if aSwitch.switch.isOn {
                        $0.switch.isOn = false
                    } else {
                       aSwitch.switch.isOn = true
                    }
                }
            }
        }
    }
}
