// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CCServerImplementation",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v15),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/Vinncz/GamePantry.git", .upToNextMajor(from: "0.1.3"))
    ],
    targets: [
        .target(
            name: "CCServerImplementation",
            dependencies: ["GamePantry"],
            path: "Source/CCServerImplementation"
        )
    ]
)
