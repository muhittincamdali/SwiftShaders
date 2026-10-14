import Foundation
import SwiftUI

extension ShaderLibrary {
    /// The Metal library that holds every SwiftShaders function.
    ///
    /// The view modifiers in this package call into this library for you. Use it directly when
    /// you want one of the package's shader functions with SwiftUI's own effect modifiers:
    ///
    /// ```swift
    /// Image(systemName: "sparkles")
    ///     .colorEffect(ShaderLibrary.swiftShaders.ssSepia(.float(1)))
    /// ```
    ///
    /// Function names start with `ss` so they never collide with shaders in your app.
    public static var swiftShaders: ShaderLibrary { ShaderLibrary.bundle(.module) }
}

/// Information about the compiled shader library.
public enum SwiftShaders {
    /// The location of the compiled Metal library inside the package's resource bundle.
    ///
    /// The value is `nil` when the package was built by a tool that copies `.metal` files
    /// without compiling them: `swift build` before Swift 6.4. Xcode always compiles them.
    public static var metalLibraryURL: URL? {
        Bundle.module.url(forResource: "default", withExtension: "metallib")
    }

    /// Whether the compiled Metal library is present, so that effects can be drawn.
    ///
    /// When this is `false`, SwiftUI cannot find the shader functions and views with an effect
    /// are not drawn. Build with Xcode, or with `swift build` from Swift 6.4 or later.
    public static var isMetalLibraryAvailable: Bool { metalLibraryURL != nil }
}
