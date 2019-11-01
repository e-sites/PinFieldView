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
    @IBOutlet private weak var pinEntryView: PinFieldView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pinEntryView.sizeBehavior = .fixedWidth(50)
    }

    @IBAction func tapDismiss() {
        pinEntryView.resignFirstResponder()
    }
}
