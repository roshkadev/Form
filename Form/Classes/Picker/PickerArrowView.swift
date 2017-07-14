//
//  PickerArrowView.swift
//  Pods
//
//  Created by Paul Von Schrottky on 7/14/17.
//
//

import UIKit

class PickerArrowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backgroundColor = UIColor.green
        
        let topTriangle = triangleLayer(flipped: false)
        layer.addSublayer(topTriangle)
        
        let bottomTriangle = triangleLayer(flipped: true)
        layer.addSublayer(bottomTriangle)
    }
    
    func triangleLayer(flipped: Bool) -> CAShapeLayer {
        let triangleLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()
        let offset: CGFloat = 2
        trianglePath.move(to: CGPoint(x: bounds.midX, y: offset))
        trianglePath.addLine(to: CGPoint(x: offset, y: bounds.midY - offset))
        trianglePath.addLine(to: CGPoint(x: bounds.maxX - offset, y: bounds.midY - offset))
        trianglePath.close()
        
        if flipped {
            let mirrorOverXOrigin = CGAffineTransform(scaleX: -1.0, y: 1.0)
            let translate = CGAffineTransform(translationX: bounds.width, y: 0)
            trianglePath.apply(mirrorOverXOrigin)
            trianglePath.apply(translate)
            
        }
        
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.white.cgColor
        triangleLayer.anchorPoint = .zero
        triangleLayer.name = "triangle"
        return triangleLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
