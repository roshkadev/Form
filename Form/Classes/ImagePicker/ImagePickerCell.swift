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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
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
    }
    
    func showBorder() {
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
