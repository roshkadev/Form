//
//  Form.swift
//  Pods
//
//  Created by Roshka on 4/21/17.
//
//
//  - Show and hide field(s) DONE
//  - Add new field (Switch) DONE
//  - Add new field (Slider) DONE
//  - Add new field (Stepper) DONE
//  - Support device text size DONE
//  - Support rotation DONE
//  - Stop scroll on edges of fields DONE
//  - Add new field (SegmentedSwitch) DONE
//  - Add new Picker type (keyboard and table view based actionsheet)
//  - Add new field Location (apple maps)
//  - Add new field Image (gallery and camera)
//  - Add new field File (via Activity VC, photo or video, iCloud Drive, Dropbox, Google Drive
//  - Add new field Contact
//  - Add Switch radio groups
//  - Add Check radio groups
//  - Add option to hide and also to disable fields
//  - Add Input security groupings
//  - Add custom field example
//  - Add currency option for Inputs
//  - Add tags for text view and text field
//  - Multiple fields on the same row
//  - Input formatters:
//      - Currency
//      - Phone numbers
//      - Credit cards
//      - 
//  - Required/non-required fields, asterisks to denote
//  - Labels options:
//      - leading aligned inside field (align input areas)
//      - floating
//      - above field
//  - Input option to include leading/trailing icon
//  - Include in README examples of forms such as contact on iOS, hotel, booking, signup, etc.
//  - Add option to field to show help text.
//  - Field hint popover box

//  - UI tests
//  - Unit tests




//  - Smart navigation to go to next Field (even if not a first responder), ignore hidden fields.
//  - Ignore hidden fields when validating a form
//  - Add label types (above, inset, floating)
//  - Add new field (TextArea) with dynamic height and placeholder
//  - Add new field (Check) with dynamic height and placeholder
//  - Date picker, add common date formatters


import UIKit

public class Form: NSObject {
    
    /// The containing view controller.
    var viewController: UIViewController
    
    /// The view of the containing view (normally the containing view controller's view).
    var containingView: UIView
    
    /// A scroll view to allow the form to scroll vertically.
    var scrollView: FormScrollView
    
    /// The vertical stack view contains one arranged subview for each row.
    var verticalStackView: UIStackView
    
    /// The form's rows (a row contains one or more fields).
    var rows: [Row]
    
    /// The form's fields.
    var fields: [Field]
    
    var activeField: Field?
    var enableNavigation = true
    var isPagedScrollingEnabled = false
    
    var nextView: UIView!
    var nextButton: UIButton!
    var nextViewVerticalConstraint: NSLayoutConstraint!
    var currentField: Field?
    
    /// The constraint used to add fields.
    var bottomLayoutConstraint: NSLayoutConstraint?
    
    let nextButtonWidth: CGFloat = 30
    
    @discardableResult
    public init(in viewController: UIViewController, constructor: ((Form) -> Void)? = nil) {
        
        self.viewController = viewController
        containingView = viewController.view
        scrollView = FormScrollView()
        verticalStackView = UIStackView()
        rows = []
        fields = []
        
        super.init()
        
        scrollView.form = self
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(scrollView)
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: [ "scrollView": scrollView ]))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: [ "scrollView": scrollView ]))
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(verticalStackView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[verticalStackView]|", options: [], metrics: nil, views: [ "verticalStackView": verticalStackView ]))
        containingView.addConstraint(NSLayoutConstraint(item: verticalStackView, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1, constant: 0))
        containingView.addConstraint(NSLayoutConstraint(item: containingView, attribute: .right, relatedBy: .equal, toItem: verticalStackView, attribute: .right, multiplier: 1, constant: 0))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[verticalStackView]|", options: [], metrics: nil, views: [ "verticalStackView": verticalStackView ]))
        
        
        // Add the fields to the form.
        constructor?(self)
        
        // Register for keyboard notifications to allow form fields to avoid the keyboard.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // Register for dynamic type changes.
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeContentSizeCategory), name: .UIContentSizeCategoryDidChange, object: nil)
        
        nextView = UIView()
        nextView.backgroundColor = .green
        nextView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(nextView)
        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("▶️", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        nextView.addSubview(nextButton)
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[nextView(\(nextButtonWidth))]|", options: [], metrics: nil, views: [ "nextView": nextView ]))
        containingView.addConstraint(NSLayoutConstraint(item: nextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 50))
        nextViewVerticalConstraint = NSLayoutConstraint(item: nextView, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1, constant: 0)
        containingView.addConstraint(nextViewVerticalConstraint!)
        
        nextView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[nextButton]|", options: [], metrics: nil, views: [ "nextButton": nextButton ]))
        nextView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nextButton]|", options: [], metrics: nil, views: [ "nextButton": nextButton ]))
        
    }
    
    public var parameters: [String: Any]? {
        return fields.reduce([String: Any](), { partialResult, field in
            guard let key = field.key else { return partialResult }
            guard let value = field.value else { return partialResult }
            var updatedResult = partialResult
            updatedResult[key] = value
            return updatedResult
        })
    }
    
    deinit {
        print("Form deinitialized")
    }
}

extension Form: UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard isPagedScrollingEnabled else { return }
        
        print("original target: ", targetContentOffset.pointee)
        var targetOffset = targetContentOffset.pointee
        targetOffset.x = scrollView.center.x
        let scrollHeight = scrollView.bounds.height - scrollView.contentInset.bottom
        
        targetOffset.y += scrollHeight
        print("target: ", targetOffset)
        print("scrollView: ", scrollView.bounds.height)
        print("scrollView bottom: ", scrollView.contentInset.bottom)
        let field = fields.filter {
            return $0.view.frame.contains(targetOffset)
        }.first
        if let field = field {
            
            let finalTargetOffset = field.view.frame.origin.y - scrollHeight + field.view.frame.height
            print("Found: ", finalTargetOffset)
            targetContentOffset.pointee.y = finalTargetOffset
        }

        
        
//        let targetCellIndexPath = self.indexPathForRowAtPoint(targetContentOffsetCorrected)
//        
//        let targetCellRect = self.rectForRowAtIndexPath(targetCellIndexPath!)
//        
//        var targetCellYCenter = targetCellRect.origin.y
//        
//        let isJumpingDown = (targetContentOffsetCorrected.y % cellHeight) > (cellHeight / 2)
//        
//        if isJumpingDown == true {
//            let nextPlace = Int(targetContentOffsetCorrected.y) / Int(cellHeight)
//            targetCellYCenter = (CGFloat(nextPlace) * cellHeight) + cellHeight
//        }
//        
//        targetContentOffset.memory.y = targetCellYCenter - contentInsetY
    }
}

extension Form {

    @discardableResult
    public func add(field: Field) -> Self {
        let row = Row(in: self)
        row.horizontalStackView.addArrangedSubview(field.view)
        add(row: row)
        
        // Take the current dynamic font.
        field.didChangeContentSizeCategory()
        
        return self
    }
    
    @discardableResult
    public func add(row: Row) -> Self {
        verticalStackView.addArrangedSubview(row.horizontalStackView)
        return self
    }
    
    @discardableResult
    public func navigation(_ navigation: Bool) -> Self {
        enableNavigation = navigation
        fields.flatMap { $0 as? Input }.forEach {
            if $0.textField.keyboardType == .numberPad || $0.textField.keyboardType == .decimalPad || $0.textField.keyboardType == .phonePad {
                $0.textField.inputAccessoryView = NextInputAccessoryView()
            } else {
                $0.textField.returnKeyType = .next
            }
        }
        
        fields.flatMap { $0 as? Picker }.forEach {
//            $0.textField?.inputAccessoryView = NextInputAccessoryView()
        }
        
        return self
    }
    
    @discardableResult
    public func pagedScrolling(_ pagedScrolling: Bool) -> Self {
        isPagedScrollingEnabled = pagedScrolling
        return self
    }
    
    internal func assign(activeField: Field) {
        self.activeField = activeField
    }
    
    /// Assign the next field as first responder.
    internal func didTapNextFrom(field: Field) {
        
        func moveNextButton(to toField: Field?) {
            if let constraint = nextViewVerticalConstraint {
                containingView.removeConstraint(constraint)
            }
            
            guard let toField = toField else {
                nextView.isHidden = true
                return
            }
            
            nextView.isHidden = false
            toField.rightContainerLayoutConstraint.constant = 100
            toField.rightScrollLayoutConstraint.constant = 100
            
            nextViewVerticalConstraint = NSLayoutConstraint(item: nextView, attribute: .bottom, relatedBy: .equal, toItem: toField.view, attribute: .bottom, multiplier: 1, constant: 0)
            containingView.addConstraint(nextViewVerticalConstraint!)
            currentField = toField
        }
        
        func moveFocus(fromField: Field, toField: Field) {
            if toField.canBecomeFirstResponder {
                toField.becomeFirstResponder()
                if toField.canShowNextButton == false {
                    moveNextButton(to: toField)
                } else {
                    moveNextButton(to: nil)
                }
            } else {
                fromField.resignFirstResponder()
                moveNextButton(to: toField)
            }
        }
        
        let index = fields.filter { $0.view.isHidden == false }.index { $0.view == field.view }
        if let nextIndex = index?.advanced(by: 1), fields.indices.contains(nextIndex) {
            let nextField = fields[fields.startIndex.distance(to: nextIndex)]
            moveFocus(fromField: field, toField: nextField)
        } else {
            // Wrap around to bring focus to the first field in the form.
            if fields.indices.contains(fields.startIndex) {
                let nextField = fields[fields.startIndex]
                moveFocus(fromField: field, toField: nextField)
            }
        }
    }
    
    func nextButtonAction(button: UIButton) {
        if let field = currentField {
            didTapNextFrom(field: field)
        }
    }
}



extension Form {
    
    // #MARK: - Notifications
    
    func keyboardWillShow(notification: Notification) {
        
        if let info = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardHeight = info.cgRectValue.size.height
            let contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    func keyboardDidShow(notification: Notification) {
        if let info = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue, let activeView = activeField?.view, let bottomPadding = activeField?.padding.bottom {
            let keyboardHeight = info.cgRectValue.size.height
            let statusBarHeight: CGFloat = 0 //UIApplication.shared.statusBarFrame.height
            let navBarHeight = viewController.navigationController?.navigationBar.frame.height ?? 0
            var availableRect = containingView.frame
            availableRect.origin.y = statusBarHeight + navBarHeight
            availableRect.size.height -= keyboardHeight - statusBarHeight - navBarHeight
            if availableRect.contains(activeView.frame) == false {
                print(scrollView.frame, scrollView.contentSize, activeView.frame)
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y + bottomPadding), animated: true)
            }
            
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    func didChangeContentSizeCategory(notification: Notification) {
        fields.forEach { $0.label?.assignPreferredFont() }
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
