// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rotate-tool",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "RotateTool", targets: ["RotateTool"])
    ],
    targets: [
        .target(name: "RotateTool")
    ]
)
