import Foundation

/// Main entry point for the SwiftShaders ecosystem.
public enum SwiftShaders {
    public static let version = "2.0.0"
}

/// A base protocol for shader configurations.
public protocol ShaderConfig: Sendable {
    var intensity: Float { get }
}
