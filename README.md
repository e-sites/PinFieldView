# PinFieldView

Entering PIN codes made easy

[![Platform](https://img.shields.io/cocoapods/p/PinFieldView.svg?style=flat)](http://cocoadocs.org/docsets/PinFieldView)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PinFieldView.svg)](http://cocoadocs.org/docsets/PinFieldView)
[![Travis-ci](https://travis-ci.com/e-sites/PinFieldView.svg?branch=master)](https://travis-ci.org/e-sites/PinFieldView)

<img src="Assets/screenshot.png" style="width:200px">


## Installation

### CocoaPods

Podfile:

```ruby
pod 'PinFieldView'
```

And then

```
pod install
```

### SwiftPM

Add the following line to your dependencies:

```swift
.package(url: "https://github.com/e-sites/PinFieldView.git", .upToNextMajor(from: "1.0.0"))
```


## Implementation

You can either add your `PinFieldView` to a XIB or storyboard or you can add it programatically:

```swift
import PinEntryType
import UIKit

let entryView = PinFieldView(frame: CGRect(x: 10, y: 10, width: 300, height: 64))
entryView.sizeBehavior = .fixedWidth(64) // This will make all the entries equal sized
entryView.digits = 5 // 5 digit pin code
entryView.viewType = EntryView.self // it must enherit from PinFieldViewable and UIView
view.addSubview(entryView)
```

Make your own entry view item:

```swift
import UIKit

class EntryView: UILabel, PinFieldViewable {
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

### Variables

|Variable|Distinction|Description|
|----|----|-------|
|`value: String`|`{ get }`|Returns the typed pincode (e.g. "12345")|
|`views: [PinEntryTypeUIView]`|`{ get }`|The current entry item views, so you can use them as you like|
|`isFilled: Bool`|`{ get }`|Are all the entry fields filled in?|
|`sizeBehavior: SizeBehavior`|`{ get set }`|[See size behavior](#sizebehavior) (Default: `.spacing(10)`|
|`digits: Int`|`{ get set }`|The number of digits (Default: 4, Min: 1, Max: 10)|
|`viewType: PinEntryTypeUIView.Type`|`{ get set }`|[See view types](#viewtype) (Default: `DefaultEntryType.self`)|


### Functions

|Function|Description|
|----|----|-------|
|`func clear()`|Clears all the entry fields|

## Configuration

<a name="#sizebehavior"></a>
### Size behavior

There are two options when it comes to the size of the digit views:

1. Fixed width → `SizeBehavior.fixedWidth(CGFloat)`
2. Fixed spacing → `SizeBehavior.spacing(CGFloat)`

<a name="#viewtype"></a>
### View types

This is probably the most important part of this class, a view type will define how the individual digits entry fields will look like.   
Create a new class that extends `UIView` and implements the `PinEntryViewType` protocol.

Within that class there are 3 important things you need to take care of

#### Highlighted state

`becomeFirstResponder()` will be called once the field is active, the code below will make the view's background orange when you need to enter a digit for that specific field.

```swift
override public func becomeFirstResponder() -> Bool {
    backgroundColor = UIColor.orange
    return true
}
```

#### Dropping highlighted state

`resignFirstResponder()` will be called once the field is not active anymore, the code below will make the view's background white again.

```swift
override public func resignFirstResponder() -> Bool {
    backgroundColor = UIColor.white
    return true
}
```

#### 3. When the users enters (or removes) a digit

That is where the `PinEntryViewType` protocol comes in place, we need to implement `var digitValue: Int?`, so this view knows what digit the user entered. In this particular example the background will turn green once a number is entered, otherwise (defaults) to white.

```swift
var digitValue: Int? {
	didSet {
		backgroundColor = digitValue == nil ? UIColor.white : UIColor.green
	}
}
```

Above code will result in something like this:

```swift
import Foundation
import UIKit
import PinEntryView

public class DigitEntryView: UIView, PinEntryViewType {

    public var digitValue: Int? {
        didSet {
            backgroundColor = digitValue == nil ? UIColor.white : UIColor.green
        }
    }

    override public func becomeFirstResponder() -> Bool {
        backgroundColor = UIColor.orange
        return true
    }

    override public func resignFirstResponder() -> Bool {
        backgroundColor = UIColor.white
        return true
    }
}
```