//
//  Restrict.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/23/17.
//
// Call cocoapod "Torn"

/// An `Event` associated with a `Field`.
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

/// A `Reaction` is the response by a `Field` to a `Restriction`
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


/// `OnValidationEvent` is a protocol used to bind a `Restriction` to a `Event` on a `Field`.
public protocol OnValidationEvent: class, Field {
    
    var validations: [Validation] { get set }
    func on(_ event: Event, _ restriction: Restriction) -> Self
    func on(_ event: Event, _ restriction: Restriction, _ reaction: Reaction) -> Self
    func validateForEvent(event: Event) -> Bool
}

/// Provide a default implementation of the `OnValidationEvent`.
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

/// `OnHandleEvent` is a protocol used to bind an event handler to an `Event`.
public protocol OnHandleEvent: class, Field {
    var handlers: [(event: Event, handler: ((Self) -> Void))] { get set }
    func on(_ event: Event, handler: @escaping ((Self) -> Void)) -> Self
}


