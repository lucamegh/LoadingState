// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LoadingState",
    products: [
        .library(
            name: "LoadingState",
            targets: ["LoadingState"]
        ),
    ],
    targets: [
        .target(
            name: "LoadingState",
            dependencies: []
        ),
        .testTarget(
            name: "LoadingStateTests",
            dependencies: ["LoadingState"]
        ),
    ]
)
