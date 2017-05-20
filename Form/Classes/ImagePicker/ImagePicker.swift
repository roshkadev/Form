//
//  ImagePicker.swift
//  Pods
//
//  Created by Paul Von Schrottky on 5/16/17.
//
//
// Usage: Don't forget NSPhotoLibraryUsageDescription

import UIKit

final public class ImagePicker: NSObject {
    public var form: Form
    public var view: FieldView
    public var label: FieldLabel?
    public var key: String?
    public var attachedTo: InputKey?
    public var topLayoutConstraint: NSLayoutConstraint?
    public var rightContainerLayoutConstraint: NSLayoutConstraint!
    public var rightScrollLayoutConstraint: NSLayoutConstraint!
    public var padding = Space.default
    var imagePickerView: ImagePickerView
    
    var images = [UIImage]()
    
    var cellDimension: CGFloat = 100

    @discardableResult
    public init(_ form: Form) {
        
        self.form = form
        view = FieldView()
        label = FieldLabel()
        imagePickerView = UINib(nibName: "ImagePickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: nil, options: nil)[0] as! ImagePickerView
        
        super.init()
        
        
        imagePickerView.delegate = self
        imagePickerView.collectionView.register(UINib(nibName: "ImagePickerCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "imagePickerCellReuseIdentifier")
        imagePickerView.collectionView.dataSource = self
        imagePickerView.collectionView.delegate = self
        imagePickerView.adjustHeightToFitContent()
        
        Utilities.constrain(field: self, withView: imagePickerView)
        
        form.add { self }
    }
}

extension ImagePicker: ImagePickerViewDelegate {
    
}

extension ImagePicker: Field {
    
    public func didChangeContentSizeCategory() {
    
    }
    
    @discardableResult
    public func style(_ style: ((ImagePicker) -> Void)) -> Self {
        style(self)
        return self
    }
}

extension ImagePicker: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagePickerCellReuseIdentifier", for: indexPath) as! ImagePickerCell
        
        switch indexPath.item {
        case 0:
            cell.label.text = "📷"
            cell.showBorder()
        case 1:
            cell.label.text = "🖼️"
            cell.showBorder()
        default:
            cell.imageView.image = images[indexPath.row - 2]
            break
        }
        return cell
    }
}

extension ImagePicker: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch indexPath.item {
        case 0:
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .camera
            form.viewController.present(imagePickerController, animated: true, completion: nil)
        case 1:
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            form.viewController.present(imagePickerController, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension ImagePicker: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellDimension, height: cellDimension)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            images.append(image)
        }
        imagePickerView.reloadCollectionView()
        form.viewController.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        form.viewController.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
