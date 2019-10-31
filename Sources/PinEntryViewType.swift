//
//  PinEntryViewType.swift
//  PinEntryView
//
//  Created by Bas van Kuijck on 31/10/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import Foundation
import UIKit

public protocol PinEntryViewType: UIResponder {
    init()
    var digitValue: Int? { get set }
}
