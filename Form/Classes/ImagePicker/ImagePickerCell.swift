//
//  ImagePickerCell.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/16/17.
//
//

import UIKit

class ImagePickerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reset()
    }
    
    override var bounds: CGRect {
        didSet {
            if let gradientLayer = gradientLayer {
                gradientLayer.removeFromSuperlayer()
            }
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
            gradientLayer.locations = [0, 1]//stride(from: 0, to: 1, by: 0.2).map { NSNumber(value: $0) }
            imageView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    fileprivate func reset() {
        imageView.image = nil
        label.text = nil
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    func showBorder() {
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
