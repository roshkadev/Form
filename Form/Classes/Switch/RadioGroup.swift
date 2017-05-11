//
//  SwitchGroup.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/9/17.
//
//

import UIKit

public protocol RadioProtocol: Field {
    var isOn: Bool { get set }
    func on(_ callback: @escaping (Bool) -> ())
}

public protocol RadioGroupProtocol {
    
}

final public class RadioGroup<T>: NSObject {
    
    @discardableResult
    public init(_ form: Form, _ addFields: (T) -> ()) {
        
        let before = form.fields.flatMap { $0 as? RadioProtocol }
        addFields()
        let after = form.fields.flatMap { $0 as? RadioProtocol }
        let added = after.filter {
            before.map { $0.view }.contains($0.view) == false
        }
        
        for (_, var new) in added.enumerated() {
            new.on { isOn in
                
                let others = added.filter { $0.view != new.view }
                for (_, var other) in others.enumerated() {
                    if isOn {
                        other.isOn = false
                    } else {
                        new.isOn = true
                    }
                }
            }
        }
    }
}
