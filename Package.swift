// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PinEntryView",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "PinEntryView", targets: ["PinEntryView"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PinEntryView",
            dependencies: [
            ],
            path: "Sources"
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
