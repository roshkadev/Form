//
//  Space.swift
//  Pods
//
//  Created by Paul Von Schrottky on 4/21/17.
//
//

import UIKit

public struct Space: OptionSet {
    public let rawValue : Int
    public init(rawValue: Int) { self.rawValue = rawValue}
    let space: CGFloat = 16
    static let none         	=       Space(rawValue: 0 << 0)
    static let top              =       Space(rawValue: 1 << 1)
    static let right            =       Space(rawValue: 1 << 2)
    static let bottom           =       Space(rawValue: 1 << 3)
    static let left             =       Space(rawValue: 1 << 4)
    static let `default`        =       Space.top.union(.left).union(.right)
    
    var top: CGFloat {
        return contains(.top) ? space : 0
    }
    
    var right: CGFloat {
        return contains(.right) ? space : 0
    }
    
    var bottom: CGFloat {
        return contains(.bottom) ? space : 0
    }
    
    var left: CGFloat {
        return contains(.left) ? space : 0
    }
}
