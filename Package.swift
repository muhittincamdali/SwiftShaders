// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftShaders",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SwiftShaders",
            targets: ["SwiftShaders"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftShaders",
            resources: [
                .process("Shaders/Ripple"),
                .process("Shaders/ChromaticAberration"),
                .process("Shaders/Glitch"),
                .process("Shaders/Pixelate"),
                .process("Shaders/Wave"),
                .process("Shaders/Noise"),
                .process("Shaders/Dissolve"),
                .process("Shaders/Hologram"),
                .process("Shaders/Blur"),
                .process("Shaders/ColorGrading"),
                .process("Shaders/Distortion"),
                .process("Shaders/Fire"),
                .process("Shaders/Water"),
                .process("Shaders/Electric"),
            ]
        ),
        .testTarget(
            name: "SwiftShadersTests",
            dependencies: ["SwiftShaders"]
        ),
    ]
)
