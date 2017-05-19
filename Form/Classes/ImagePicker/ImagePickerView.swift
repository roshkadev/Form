//
//  ImagePickerView.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/16/17.
//
//

import UIKit

protocol ImagePickerViewDelegate {
    var cellDimension: CGFloat { get set }
    func didLongPressWith(gestureRecognizer: UILongPressGestureRecognizer)
}

public class ImagePickerView: UIView {
    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: ImagePickerViewDelegate!
    var heightConstraint: NSLayoutConstraint!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        addConstraint(heightConstraint)
    }
    
    func adjustHeightToFitContent() {
        heightConstraint.constant = delegate.cellDimension
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil) { _ in
            self.heightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        delegate.didLongPressWith(gestureRecognizer: gestureRecognizer)
    }
    
    deinit {
        print("ImagePickerView deinited")
    }
}
