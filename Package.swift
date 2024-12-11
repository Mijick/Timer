// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickTimer",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "MijickTimer", targets: ["MijickTimer"]),
    ],
    targets: [
        .target(name: "MijickTimer", dependencies: [], path: "Sources"),
        .testTarget(name: "MijickTimerTests", dependencies: ["MijickTimer"], path: "Tests")
    ],
    swiftLanguageModes: [.v6]
)
