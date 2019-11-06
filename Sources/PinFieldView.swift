//
//  PinFieldView.swift
//  PinFieldView
//
//  Created by Bas van Kuijck on 31/10/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import Foundation
import UIKit

public protocol PinFieldViewDelegate: class {
    func pinFieldViewDidBeginEditing(_ pinFieldView: PinFieldView)
    func pinFieldViewDidEndEditing(_ pinFieldView: PinFieldView)
}

open class PinFieldView: UIControl, UIKeyInput, UITextInputTraits {

    public typealias PinFieldUIView = (UIView & PinFieldViewable)

    /// How should the pin entry views be sized?
    public enum SizeBehavior {

        /// Dynamic width, fixed spacing
        case spacing(CGFloat)

        /// Fixed width, dynamic spacing
        case fixedWidth(CGFloat)
    }

    public weak var delegate: PinFieldViewDelegate?

    /// The actual pincode
    private(set) public var value: String = "" {
        didSet {
            _updateCursor(oldValue: oldValue)
        }
    }

    private var _stackView = UIStackView()

    /// If (for some reason) you want to do stuff with the individual entry views
    private(set) public var views: [PinFieldUIView] = []


    /// Is it filled in completely?
    public var isFilled: Bool { value.count == digits }

    // MARK: - UIKeyInput
    // --------------------------------------------------------

    public var hasText: Bool { !value.isEmpty }
    
    // MARK: - UITextInputTraits
    // --------------------------------------------------------

    public var autocapitalizationType: UITextAutocapitalizationType {
        get { .none }
        set { }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get { .no }
        set { }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        get { .no }
        set { }
    }

    public var keyboardType: UIKeyboardType {
        get { .numberPad }
        set { }
    }

    public var keyboardAppearance: UIKeyboardAppearance = .default
    public var returnKeyType: UIReturnKeyType = .done
    public var enablesReturnKeyAutomatically = true

    // MARK: - IBInspectable
    // --------------------------------------------------------

    /// How many digits can it hold?
    /// Minimum: 1
    /// Maximum: 10
    @IBInspectable
    @Clamping(1...10) public var digits: Int = 4 {
        didSet {
            if digits < value.count {
                let endIndex = value.index(value.startIndex, offsetBy: digits)
                value = String(value[..<endIndex])
            }
            _updateLayout()
        }
    }

    /// The PinFieldUIView to use
    /// Make sure yout `UIView` implements the `PinFieldUIView` protocol
    public var viewType: PinFieldUIView.Type = DefaultEntryType.self {
        didSet {
            _updateLayout()
        }
    }

    /// How should the pin entry views be sized?
    public var sizeBehavior: SizeBehavior = .spacing(10) {
        didSet {
            _updateSizeBehavior()
        }
    }

    // MARK: - Initialization
    // --------------------------------------------------------

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        _setupTouch()
        _setupStackView()
    }

    private func _setupTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(_didTap))
        addGestureRecognizer(tapGesture)
    }

    private func _setupStackView() {
        backgroundColor = UIColor.clear
        _stackView.isUserInteractionEnabled = false
        _stackView.distribution = .fillEqually
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.axis = .horizontal
        addSubview(_stackView)

        NSLayoutConstraint.activate([
            _stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            _stackView.topAnchor.constraint(equalTo: topAnchor),
            _stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        _updateLayout()
    }

    // MARK: - UIKeyInput
    // --------------------------------------------------------

    public func insertText(_ text: String) {
        let text = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if value.count + text.count > digits {
            return
        }
        value += text
    }

    public func deleteBackward() {
        if value.isEmpty {
            return
        }
        _ = value.removeLast()
    }

    // MARK: - Layout
    // --------------------------------------------------------

    private func _updateLayout() {
        for view in views {
            _stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        views.removeAll()

        for _ in 0..<digits {
            let view = viewType.init()
            _stackView.addArrangedSubview(view)
            views.append(view)
        }
        _updateSizeBehavior()
        _updateCursor()
    }

    private func _updateSizeBehavior() {
        switch sizeBehavior {
        case .spacing(let spacing):
            _stackView.spacing = spacing

        case .fixedWidth(let width):
            let usedWidth = CGFloat(digits) * width
            _stackView.spacing = (frame.size.width - usedWidth) / CGFloat(digits - 1)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if case SizeBehavior.fixedWidth = sizeBehavior {
            _updateSizeBehavior()
        }
    }

    // MARK: - Interaction
    // --------------------------------------------------------

    /// Clears all the digits
    public func clear() {
        value = ""
    }

    @objc
    private func _didTap() {
        becomeFirstResponder()
    }

    override open var canBecomeFirstResponder: Bool {
        return true
    }

    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        // When this view becomes active and it's already filled in, reset it.
        if isFilled {
            clear()
        }
        defer {
            _updateCursor()
        }
        delegate?.pinFieldViewDidBeginEditing(self)
        return super.becomeFirstResponder()
    }

    @discardableResult
    override open func resignFirstResponder() -> Bool {
        defer {
            _updateCursor()
        }
        delegate?.pinFieldViewDidEndEditing(self)
        return super.resignFirstResponder()
    }

    // MARK: - Cursor
    // --------------------------------------------------------

    private func _updateCursor(oldValue: String? = nil) {
        for (index, view) in views.enumerated() {
            if index < value.count {
                let startIndex = value.index(value.startIndex, offsetBy: index)
                let endIndex = value.index(startIndex, offsetBy: 1)
                view.digitValue = Int(String(value[startIndex..<endIndex]))
            } else {
                view.digitValue = nil
            }
            _ = view.resignFirstResponder()
        }

        if !isFirstResponder {
            return
        }

        // The last digit is entered -> resignFirstResponder
        if let oldValue = oldValue, oldValue.count == digits - 1, value.count == digits {
            _ = resignFirstResponder()
            return
        }

        let activeIndex = min(value.count, digits - 1)
        _ = views[activeIndex].becomeFirstResponder()

    }
}
