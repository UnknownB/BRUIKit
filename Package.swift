// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BRUIKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BRUIKit",
            targets: ["BRUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/UnknownB/BRFoundation", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BRUIKit", dependencies: ["BRFoundation"]
        ),
        .testTarget(
            name: "BRUIKitTests",
            dependencies: ["BRUIKit"]
        ),
    ]
)
