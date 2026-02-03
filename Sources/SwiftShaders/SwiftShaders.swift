// SwiftShaders
// A comprehensive Metal shader library for SwiftUI

@_exported import SwiftUI

// MARK: - Core
@_exported import struct SwiftUI.Shader

// This file serves as the main entry point for the SwiftShaders library.
// All public APIs are exported through individual module files.

/// SwiftShaders library version information.
public enum SwiftShadersInfo {
    /// The current version of SwiftShaders.
    public static let version = "1.0.0"
    
    /// The minimum iOS version required.
    public static let minimumIOSVersion = "17.0"
    
    /// The minimum macOS version required.
    public static let minimumMacOSVersion = "14.0"
    
    /// Library description.
    public static let description = "A comprehensive Metal shader library for SwiftUI with 30+ visual effects."
    
    /// GitHub repository URL.
    public static let repositoryURL = "https://github.com/muhittinpalamutcu/SwiftShaders"
}
