//
//  DefaultEntryType.swift
//  PinEntryView
//
//  Created by Bas van Kuijck on 31/10/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import Foundation
import UIKit

public class DefaultEntryType: UILabel, PinEntryViewType {

    public var digitValue: Int? {
        didSet {
            text = digitValue == nil ? nil : "*"
        }
    }

    // MARK: - Initialization
    // --------------------------------------------------------

    convenience required public init() {
        self.init(frame: CGRect.zero)
        layer.borderColor = UIColor.orange.cgColor
        backgroundColor = UIColor.darkGray
        textAlignment = .center
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    }

    override public func becomeFirstResponder() -> Bool {
        layer.borderWidth = 2
        return true
    }

    override public func resignFirstResponder() -> Bool {
        layer.borderWidth = 0
        return true
    }
}
