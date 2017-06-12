//
//  Space.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/21/17.
//
//

import UIKit

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
    
    
    public static let none         	=       Space(rawValue: 0 << 0)
    public static let top              =       Space(rawValue: 1 << 1)
    public static let right            =       Space(rawValue: 1 << 2)
    public static let bottom           =       Space(rawValue: 1 << 3)
    public static let left             =       Space(rawValue: 1 << 4)
    public static let `default`        =       Space([.top, .right, .bottom, .left])
    
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
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
}
