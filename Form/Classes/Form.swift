//
//  Form.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//

import UIKit

public protocol FormItem {
    var view: UIView { get set }
}

public struct FormSpace: OptionSet {
    public let rawValue : Int
    public init(rawValue: Int) { self.rawValue = rawValue}
    let space: CGFloat = 16
    static let None         	=       FormSpace(rawValue: 0)
    static let Top              =       FormSpace(rawValue: 1 << 1)
    static let TopDbl           =       FormSpace(rawValue: 1 << 2)
    static let TopTri           =       FormSpace(rawValue: 1 << 3)
    static let Right            =       FormSpace(rawValue: 1 << 4)
    static let Bottom           =       FormSpace(rawValue: 1 << 5)
    static let Left             =       FormSpace(rawValue: 1 << 6)
    static let BottomDbl        =       FormSpace(rawValue: 1 << 7)
    static let BottomTri        =       FormSpace(rawValue: 1 << 8)
    static let StdWidth         =       FormSpace.Left.union(.Right)
    static let Default          =       FormSpace.Top.union(.StdWidth)
    static let Last             =       FormSpace.Top.union(.BottomTri).union(.StdWidth)
    static let LastFullWidth    =       FormSpace.Top.union(.BottomTri)
    
    var top: CGFloat {
        if contains(.TopTri) {
            return space * 3
        } else if contains(.TopDbl) {
            return space * 2
        } else if contains(.Top) {
            return space
        } else {
            return 0
        }
    }
    
    var right: CGFloat {
        return contains(.Right) ? space : 0
    }
    
    var bottom: CGFloat {
        if contains(.BottomTri) {
            return space * 3
        } else if contains(.BottomDbl) {
            return space * 2
        } else if contains(.Bottom) {
            return space
        } else {
            return 0
        }
    }
    
    var left: CGFloat {
        return contains(.Left) ? space : 0
    }
}


public class Form: NSObject {
    var scrollView: UIScrollView!
    
    var containingView: UIView!
    
    @discardableResult
    public init(in viewController: UIViewController) {
        containingView = viewController.view
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.green
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(scrollView)
        let autolayoutViews: [String: Any] = [
            "scrollView": scrollView
        ]
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: autolayoutViews))
        
    }
    
    @discardableResult
    public func add(_ space: FormSpace = .Default, _ add: ((Void) -> FormItem?)) -> Self {
        
        guard let widget = add() else { return self }
        let item = (widget, space)
        
        scrollView.addSubview(widget.view)
        
        let autolayoutViews: [String: UIView] = [
            "widgetView": widget.view
        ]
        containingView.addConstraint(NSLayoutConstraint(item: widget.view, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1, constant: 0))
        containingView.addConstraint(NSLayoutConstraint(item: widget.view, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1, constant: 0))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[widgetView]", options: [], metrics: nil, views: autolayoutViews))
        
        return self
    }

    
}
