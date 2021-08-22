// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RemoteRequest",
    platforms: [
        .iOS(.v11),
        .tvOS(.v9),
        .watchOS(.v2),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "RemoteRequest",
            targets: ["RemoteRequest"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RemoteRequest",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "RemoteRequestTests",
            dependencies: ["RemoteRequest"],
            path: "Tests"
        ),
    ]
)
