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
    
    // #MARK - Field
    public var form: Form!
    public var row: Row!
    public var view: FieldView
    public var contentView: UIView
    public var helpLabel = HelpLabel()
    public var stackView: UIStackView
    public var title: String?
    public var label: FieldLabel?
    public var key: String?
    public var attachedTo: InputKey?
    public var padding = Space.default
    var imagePickerView: ImagePickerView
    
    var images = [UIImage]()
    
    var cellDimension: CGFloat = 100
    public var formBindings = [(event: FormEvent, field: Field, handler: ((Field) -> Void))]()
    
    let fixedIndexPaths = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)]
    let defaultIndexPath = IndexPath(item: 2, section: 0)

    @discardableResult
    override public init() {

        view = FieldView()
        stackView = UIStackView()
        label = FieldLabel()
        imagePickerView = UINib(nibName: "ImagePickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: nil, options: nil)[0] as! ImagePickerView
        contentView = imagePickerView
        super.init()
        

        imagePickerView.delegate = self
        imagePickerView.collectionView.register(UINib(nibName: "ImagePickerCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "imagePickerCellReuseIdentifier")
        imagePickerView.collectionView.dataSource = self
        imagePickerView.collectionView.delegate = self
        imagePickerView.adjustHeightToFitContent()
        
        Utilities.constrain(field: self, withView: imagePickerView)
    }
}

extension ImagePicker: ImagePickerViewDelegate {
    
    func translate(indexPath: IndexPath) -> IndexPath {
        var translatedIndexPath = indexPath
        translatedIndexPath.item -= 2
        return translatedIndexPath
    }
    
    func didLongPressWith(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: imagePickerView.collectionView)
        
        switch gestureRecognizer.state {
            
        case .began:
            guard let selectedIndexPath = imagePickerView.collectionView.indexPathForItem(at: point) else { break }
            imagePickerView.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            imagePickerView.collectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            imagePickerView.collectionView.endInteractiveMovement()
        default:
            imagePickerView.collectionView.cancelInteractiveMovement()
        }
    }

    
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
            let alertController = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                let translatedIndex = self.translate(indexPath: indexPath).item
                self.images.remove(at: translatedIndex)
                self.imagePickerView.collectionView.deleteItems(at: [indexPath])
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.form.viewController.present(alertController, animated: true, completion: nil)
            break
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return !fixedIndexPaths.contains(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let translatedSourceIndexPath = translate(indexPath: sourceIndexPath)
        let translatedDestinationIndexPath = translate(indexPath: destinationIndexPath)
        swap(&images[translatedSourceIndexPath.item], &images[translatedDestinationIndexPath.item])
    }
    
    public func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        return fixedIndexPaths.contains(proposedIndexPath) ? defaultIndexPath : proposedIndexPath
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
