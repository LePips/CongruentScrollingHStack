// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CongruentScrollingHStack",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CongruentScrollingHStack",
            targets: ["CongruentScrollingHStack"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.0.5"),
        .package(url: "https://github.com/ra1028/DifferenceKit", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CongruentScrollingHStack",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "DifferenceKit", package: "DifferenceKit"),
            ]
        ),
    ]
)
