//
//  ImagePickerView.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/16/17.
//
//

import UIKit

public class ImagePickerView: UIView {
    @IBOutlet var collectionView: UICollectionView!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    deinit {
        print("ImagePickerView deinited")
    }
}
