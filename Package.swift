// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PinFieldView",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "PinFieldView", targets: ["PinFieldView"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PinFieldView",
            dependencies: [
            ],
            path: "Sources"
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
