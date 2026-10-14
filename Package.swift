// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftShaders",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "SwiftShaders", targets: ["SwiftShaders"])
    ],
    targets: [
        // The .metal files in Shaders/ are compiled into the target's default.metallib by Xcode and
        // by SwiftPM's Swift Build engine, the default build system from Swift 6.4. The older
        // native build system copies them without compiling.
        .target(
            name: "SwiftShaders",
            path: "Sources/SwiftShaders",
            // The header is only #included by the .metal files; it does not belong in the bundle.
            exclude: ["Shaders/ShaderCommon.h"],
            resources: [.process("Shaders")]
        ),
        .testTarget(
            name: "SwiftShadersTests",
            dependencies: ["SwiftShaders"]
        )
    ]
)
