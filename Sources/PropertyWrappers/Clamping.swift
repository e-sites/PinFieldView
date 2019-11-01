//
//  Clamping.swift
//  PinFieldView
//
//  Created by Bas van Kuijck on 31/10/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Clamping<Value: Comparable> {
    let range: ClosedRange<Value>
    private(set) var value: Value

    public init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set {
            value = min(max(range.lowerBound, newValue), range.upperBound)
        }
    }
}
