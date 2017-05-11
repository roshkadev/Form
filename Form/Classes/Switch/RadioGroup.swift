//
//  SwitchGroup.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/9/17.
//
//

import UIKit

//public protocol RadioProtocol: Field {
//    var isOn: Bool { get set }
//    func on(_ callback: @escaping (Bool) -> ())
//}
//
//public protocol RadioGroupProtocol {
//    
//}

final public class RadioGroup: NSObject {
    
    @discardableResult
    public init<T>(_ form: Form, radios: [(val: T, title: String)], binding:@escaping ((T?) -> Void)) {
        super.init()
        let fields = radios.map { radio in
            Switch(form).title(radio.title)
        }.flatMap { $0 as? Switch }

        for (idx, var field) in fields.enumerated() {
            field.onToggle { isOn in
                binding(radios[idx].val)
                if isOn {
                    let others = fields.filter { $0.view != field.view }
                    for (_, var other) in others.enumerated() {
                        other.switch.isOn = false
                    }
                } else {
                    field.switch.isOn = true
                }
            }
        }
    }
}
