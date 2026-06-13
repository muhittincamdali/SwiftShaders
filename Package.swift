// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftShaders",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftShaders", targets: ["SwiftShaders"]),
    ],
    targets: [
        .target(
            name: "SwiftShaders",
            path: "Sources/SwiftShaders",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SwiftShadersTests",
            dependencies: ["SwiftShaders"]
        )
    ]
)
