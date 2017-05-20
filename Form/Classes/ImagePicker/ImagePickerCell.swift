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
    
    var borderLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.orange
        
//        borderLayer = CAShapeLayer()
//        borderLayer!.strokeColor = UIColor.lightGray.cgColor
//        borderLayer!.fillColor = nil
//        borderLayer!.lineDashPattern = [4, 2]
//        borderLayer!.cornerRadius = 5
//        imageView.layer.addSublayer(borderLayer!)
        
        reset()
    }
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    fileprivate func reset() {
        imageView.image = nil
        label.text = nil
//        contentView.layer.borderWidth = 0
//        contentView.layer.borderColor = UIColor.clear.cgColor
//        borderLayer?.removeFromSuperlayer()
//        borderLayer = nil
    }
    
    func showBorder() {
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
