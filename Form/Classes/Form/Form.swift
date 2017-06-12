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
    var scrollView = FormScrollView()
    
    /// The vertical stack view contains one arranged subview for each row.
    var verticalStackView = UIStackView()
    
    /// The form's rows (a row contains one or more fields).
    var rows = [Row]()
    
    /// The form's fields.
    var fields: [Field] {
        return rows.flatMap { $0.fields }
    }
    
    var activeField: Field?
    var enableNavigation = true
    var isPagedScrollingEnabled = false
    
    var nextView: UIView!
    var nextButton: UIButton!
    var nextViewVerticalConstraint: NSLayoutConstraint!
    var currentField: Field?
    
    let nextButtonWidth: CGFloat = 30
    
    public var padding = Space.default
    
    @discardableResult
    public init(in viewController: UIViewController, padding: Space = .none, constructor: ((Form) -> Void)? = nil) {
        
        self.viewController = viewController
        self.padding = padding
        containingView = viewController.view
        
        super.init()
        
        scrollView.form = self
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(scrollView)
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(padding.left))-[scrollView]-(\(padding.right))-|", options: [], metrics: nil, views: [ "scrollView": scrollView ]))
        containingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(padding.top))-[scrollView]-(\(padding.bottom))-|", options: [], metrics: nil, views: [ "scrollView": scrollView ]))
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(verticalStackView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[verticalStackView]|", options: [], metrics: nil, views: [ "verticalStackView": verticalStackView ]))
        containingView.addConstraint(NSLayoutConstraint(item: verticalStackView, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1, constant: 0))
        containingView.addConstraint(NSLayoutConstraint(item: containingView, attribute: .right, relatedBy: .equal, toItem: verticalStackView, attribute: .right, multiplier: 1, constant: 0))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[verticalStackView]|", options: [], metrics: nil, views: [ "verticalStackView": verticalStackView ]))
        
//        let spaceView = UIView()
//        spaceView.translatesAutoresizingMaskIntoConstraints = false
//        spaceView.backgroundColor = UIColor.green
//        spaceView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
//        verticalStackView.addArrangedSubview(spaceView)
        
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
    
    public var isValid: Bool {
        return fields.reduce(true) { partialResult, input in
            let isInputValid = input.isValidForSubmit()
            return partialResult && isInputValid
        }
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

    /// Add a field to the form (the field is implicitly wrapped in a new row).
    @discardableResult
    public func add(field: Field) -> Self {
        
        Row(in: self).add(field: field)

        // Take the current dynamic font.
        field.didChangeContentSizeCategory()
        
        return self
    }
    
    /// Add a row to the form.
    @discardableResult
    public func add(row: Row) -> Self {
        verticalStackView.addArrangedSubview(row.horizontalStackView)
        rows.append(row)
        return self
    }
    
    /// Add a view to the form.
    @discardableResult
    public func add(view: UIView) -> Self {
        
        Row(in: self).add(view: view)

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
    
//    internal func moveNextButton(to field: Field?) {
//        if let constraint = nextViewVerticalConstraint {
//            containingView.removeConstraint(constraint)
//        }
//        
//        guard let toField = field else {
//            nextView.isHidden = true
//            return
//        }
//        
//        nextView.isHidden = false
//        toField.rightContainerLayoutConstraint.constant = 100
//        toField.rightScrollLayoutConstraint.constant = 100
//        
//        nextViewVerticalConstraint = NSLayoutConstraint(item: nextView, attribute: .bottom, relatedBy: .equal, toItem: toField.view, attribute: .bottom, multiplier: 1, constant: 0)
//        containingView.addConstraint(nextViewVerticalConstraint!)
//        currentField = toField
//    }
    
    internal func moveFocusFrom(field fromField: Field, toField: Field) {
        if toField.canBecomeFirstResponder {
            toField.becomeFirstResponder()
        } else {
            fromField.resignFirstResponder()
        }
    }
    
    /// Assign the next field as first responder.
    internal func didTapNextFrom(field fromField: Field) {
        
        let index = fields.filter { $0.view.isHidden == false }.index { $0.view == fromField.view }
        if let nextIndex = index?.advanced(by: 1), fields.indices.contains(nextIndex) {
            let nextField = fields[fields.startIndex.distance(to: nextIndex)]
            moveFocusFrom(field: fromField, toField: nextField)
        } else {
            // Wrap around to bring focus to the first field in the form.
            if fields.indices.contains(fields.startIndex) {
                let nextField = fields[fields.startIndex]
                moveFocusFrom(field: fromField, toField: nextField)
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
