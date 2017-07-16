//
//  LocationPicker.swift
//  Pods
//
//  Created by Paul Von Schrottky on 6/18/17.
//
//

import UIKit
import MapKit

final public class LocationPicker: NSObject {
    
    // #MARK - Field
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var contentView: UIView
    public var helpLabel = HelpLabel()
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var attachedTo: InputKey?
    public var padding = Space.default
    public var formBindings = [(event: FormEvent, field: Field, handler: ((Field) -> Void))]()
    
    public var button: UIButton

    
    @discardableResult
    override public init() {
        
        view = FieldView()
        stackView = UIStackView()
        label = FieldLabel()
        button = UIButton()
        button.setTitle("Select location", for: .normal)
        contentView = button
        super.init()
        
 
        Utilities.constrain(field: self, withView: button)
    }
}

extension LocationPicker: Field {
    
    @discardableResult
    public func style(_ style: ((LocationPicker) -> Void)) -> Self {
        style(self)
        return self
    }
    
}
