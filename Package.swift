// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlatformTest",
    platforms: [
        .macOS(.v10_15),
    ],
    targets: [
        .testTarget(name: "PlatformTest"),
    ]
)
