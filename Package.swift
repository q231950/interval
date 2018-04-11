// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "interval", 
    products: [
        .executable(
            name: "interval", 
            targets: ["interval", "Controller"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.1.0")),
        .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMajor(from: "1.7.1")),
    ],
    targets: [
        .target(
            name: "interval",
            dependencies: ["Kitura", "Controller", "HeliumLogger"]
        ),
        .target(
            name: "Controller", 
            dependencies: ["Kitura", "CloudEnvironment"]
        ),
        .testTarget(
            name: "ControllerTests",
            dependencies: ["Controller"]
        )
    ]
)
