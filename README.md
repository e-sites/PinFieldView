# PinEntryView

Entering PIN codes made easy

[![Platform](https://img.shields.io/cocoapods/p/PinEntryView.svg?style=flat)](http://cocoadocs.org/docsets/PinEntryView)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PinEntryView.svg)](http://cocoadocs.org/docsets/PinEntryView)
[![Travis-ci](https://travis-ci.org/e-sites/PinEntryView.svg?branch=master&001)](https://travis-ci.org/e-sites/PinEntryView)


## Installation

### CocoaPods

Podfile:

```ruby
pod 'PinEntryView'
```

And then

```
pod install
```

### SwiftPM

Add the following line to your dependencies:

```swift
.package(url: "https://github.com/e-sites/PinEntryView.git", .upToNextMajor(from: "1.0.0"))
```


## Implementation

You can either add your `PinEntryView` to a XIB or storyboard or you can add it programatically:

```swift
import PinEntryType
import UIKit

let entryView = PinEntryView(frame: CGRect(x: 10, y: 10, width: 300, height: 64))
entryView.sizeBehavior = .fixedWidth(64) // This will make all the entries equal sized
entryView.digits = 5 // 5 digit pin code
entryView.viewType = EntryView.self // it must enherit from PinEntryViewType and UIView
view.addSubview(entryView)
```

Make your own entry view item:

```swift
import UIKit

class EntryView: UILabel, PinEntryViewType {
	var digitValue: Int? {
        didSet {
            text = digitValue == nil ? nil : "*" // Place a * when the digit is entered
        }
    }

     convenience required init() {
        self.init(frame: CGRect.zero)
        layer.borderColor = UIColor.orange.cgColor
        backgroundColor = UIColor.darkGray
        textAlignment = .center
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    }

    override public func becomeFirstResponder() -> Bool {
        layer.borderWidth = 2 // When the item is active, show the border
        return true
    }

    override public func resignFirstResponder() -> Bool {
        layer.borderWidth = 0 // When the item is inactive, hide the border
        return true
    }
}

```

if you want to access the pincode:

```swift
entryView.value // will return a string (e.g. "12345")
```