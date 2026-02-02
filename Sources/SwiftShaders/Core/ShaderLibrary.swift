import SwiftUI
import Metal

/// Central registry for loading, caching, and accessing Metal shaders.
///
/// `ShaderCache` wraps SwiftUI's `ShaderLibrary` and provides a unified
/// interface for all shader functions in this package.
public final class ShaderCache: @unchecked Sendable {
    
    /// Shared singleton instance.
    public static let shared = ShaderCache()
    
    /// Cache of resolved shader functions keyed by name.
    private var cache: [String: ShaderFunction] = [:]
    
    /// Serial queue for thread-safe cache access.
    private let queue = DispatchQueue(label: "com.swiftshaders.cache")
    
    private init() {}
    
    // MARK: - Public API
    
    /// Returns the shader function for the given name.
    ///
    /// On first access the function is resolved from `ShaderLibrary.default`
    /// and cached for subsequent calls.
    ///
    /// - Parameter name: The Metal function name (e.g. `"ripple"`).
    /// - Returns: A `ShaderFunction` ready for use with SwiftUI modifiers.
    public func function(named name: String) -> ShaderFunction {
        queue.sync {
            if let cached = cache[name] {
                return cached
            }
            let fn = ShaderLibrary.default[dynamicMember: name]
            cache[name] = fn
            return fn
        }
    }
    
    /// Preloads a list of shader functions into the cache.
    ///
    /// Call this during app launch to avoid first-frame compilation stutter.
    ///
    /// - Parameter names: An array of Metal function names to preload.
    public func preload(_ names: [String]) {
        queue.sync {
            for name in names {
                if cache[name] == nil {
                    cache[name] = ShaderLibrary.default[dynamicMember: name]
                }
            }
        }
    }
    
    /// Removes all cached shader functions.
    public func clearCache() {
        queue.sync {
            cache.removeAll()
        }
    }
    
    /// The number of currently cached shader functions.
    public var cachedCount: Int {
        queue.sync { cache.count }
    }
}

// MARK: - Convenience Shader Names

/// Known shader function names shipped with SwiftShaders.
public enum ShaderName: String, CaseIterable, Sendable {
    case ripple
    case chromaticAberration = "chromatic_aberration"
    case glitch
    case pixelate
    case wave
    case noise
    case dissolve
    case hologram
    
    /// The resolved `ShaderFunction` for this shader.
    public var function: ShaderFunction {
        ShaderCache.shared.function(named: rawValue)
    }
}

// MARK: - Bundle Helpers

extension Bundle {
    /// The bundle containing SwiftShaders Metal resources.
    static var swiftShaders: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        return .main
        #endif
    }
}

// MARK: - Preload Extension

extension ShaderCache {
    /// Preloads all built-in shaders.
    public func preloadAll() {
        preload(ShaderName.allCases.map(\.rawValue))
    }
}
