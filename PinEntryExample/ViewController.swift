//
//  ViewController.swift
//  PinEntryExample
//
//  Created by Bas van Kuijck on 31/10/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import UIKit
import PinFieldView

class ViewController: UIViewController {
    @IBOutlet private weak var pinEntryView1: PinFieldView!
    @IBOutlet private weak var pinEntryView2: PinFieldView!
    @IBOutlet private weak var pinEntryView3: PinFieldView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pinEntryView1.sizeBehavior = .fixedWidth(64)
        pinEntryView2.sizeBehavior = .spacing(10)
        pinEntryView3.sizeBehavior = .spacing(20)
        pinEntryView3.viewType = EmojiEntryType.self
    }
    
    @IBAction func tapClearAll() {
        pinEntryView1.clear()
        pinEntryView2.value = ""
        pinEntryView3.value = "12"
    }
}

public class EmojiEntryType: UILabel, PinFieldViewable {

    public var digitValue: Int? {
        didSet {
            text = digitValue == nil ? "😶" : "🤩"
        }
    }

    // MARK: - Initialization
    // --------------------------------------------------------

    convenience required public init() {
        self.init(frame: CGRect.zero)
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    }

    override public func becomeFirstResponder() -> Bool {
        layer.borderColor = UIColor.yellow.cgColor
        layer.borderWidth = 4
        return true
    }

    override public func resignFirstResponder() -> Bool {
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        return true
    }
}
