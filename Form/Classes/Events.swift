//
//  Restrict.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/23/17.
//
// Call cocoapod "Torn"

import UIKit

/// `Event` encaptulates events that can trigger restrictions to be enforced.
public enum Event {
    case change
    case blur
    case submit
}

public enum Restriction {
    case empty
    case nonempty
    case max(Int)
    case min(Int)
    case range(Int, Int)
    case regex(String)
    case email
    case url
    case currency(Locale)
}

/// `Reaction` is an enumeration of ways a form field can respond
/// to restrictions.
/// e.g. Input, Select, Radio, etc.
public enum Reaction {
    case none
    case stop
    case outline
    case highlight
    case shake
    case alert(String)
    case popup(String)
    case submit(Restriction)
}

public typealias Validation = (event: Event, restriction: Restriction, reaction: Reaction)
public typealias ValidationResult = (isValid: Bool, reaction: Reaction)


/// `OnEvent` is a protocol for reference types that respresent
/// form fields whose input may be restricted in one or more ways.
/// e.g. Input, Select, Radio, etc.
public protocol OnValidationEvent: class {
    
    var validations: [Validation] { get set }
    func on(_ event: Event, _ restriction: Restriction) -> Self
    func on(_ event: Event, _ restriction: Restriction, _ reaction: Reaction) -> Self
    func validateForEvent(event: Event) -> Bool
}


public protocol OnHandleEvent: class {
    var handlers: [(event: Event, handler: ((Self) -> Void))] { get set }
    func on(_ event: Event, handler: @escaping ((Self) -> Void)) -> Self
}


extension OnValidationEvent {
    
    public func on(_ event: Event, _ restriction: Restriction) -> Self {
        validations.append(Validation(event, restriction, .stop))
        return self
    }
    
    public func on(_ event: Event, _ restriction: Restriction, _ reaction: Reaction) -> Self {
        validations.append(Validation(event, restriction, reaction))
        return self
    }
}
