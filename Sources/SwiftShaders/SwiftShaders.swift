import Foundation
import SwiftUI

extension ShaderLibrary {
    /// The Metal library that holds every SwiftShaders function.
    ///
    /// The view modifiers in this package call into this library for you. Use it directly when
    /// you want one of the package's shader functions with SwiftUI's own effect modifiers or as
    /// a fill:
    ///
    /// ```swift
    /// RoundedRectangle(cornerRadius: 16)
    ///     .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.gray)))
    /// ```
    ///
    /// Function names start with `ss` so they never collide with shaders in your app. Pass the
    /// arguments in the order of the function's parameters after the ones SwiftUI supplies
    /// (position, and color or layer); see <doc:HowEffectsAreDrawn>. A call whose arguments do
    /// not match draws nothing.
    public static var swiftShaders: ShaderLibrary { ShaderLibrary.bundle(.module) }
}

/// Information about the compiled shader library.
public enum SwiftShaders {
    /// The location of the compiled Metal library inside the package's resource bundle.
    ///
    /// The value is `nil` when the package was built by a tool that copies `.metal` files
    /// without compiling them: `swift build` with SwiftPM's native build system, the default
    /// before Swift 6.4. Xcode, and `swift build` from Swift 6.4 on, compile them.
    public static var metalLibraryURL: URL? {
        Bundle.module.url(forResource: "default", withExtension: "metallib")
    }

    /// Whether the compiled Metal library is present, so that effects can be drawn.
    ///
    /// When this is `false`, SwiftUI cannot find the shader functions and views with an effect
    /// are not drawn. Build with Xcode, or with `swift build` from Swift 6.4 or later.
    public static var isMetalLibraryAvailable: Bool { metalLibraryURL != nil }
}
