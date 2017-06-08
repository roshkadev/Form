//
//  Space.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/21/17.
//
//

import UIKit


//public enum Gap: Int {
//    case top
//    case right
//    case bottom
//    case left
//}
//
//public struct GapSet: OptionSet {
//    public let rawValue : Int
//    
//    public init(rawValue: Gap) {
//        self.rawValue = rawValue.rawValue
//    }
//}

public struct Space: OptionSet {
    let space: CGFloat = 8
    
    public let rawValue : Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    
    static let none         	=       Space(rawValue: 0 << 0)
    static let top              =       Space(rawValue: 1 << 1)
    static let right            =       Space(rawValue: 1 << 2)
    static let bottom           =       Space(rawValue: 1 << 3)
    static let left             =       Space(rawValue: 1 << 4)
    static let `default`        =       Space([.top, .right, .bottom, .left])
    
    public var top: CGFloat {
        return contains(.top) ? space : 0
    }
    
    public var right: CGFloat {
        return contains(.right) ? space : 0
    }
    
    public var bottom: CGFloat {
        return contains(.bottom) ? space : 0
    }
    
    public var left: CGFloat {
        return contains(.left) ? space : 0
    }
    
    var topConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
}
