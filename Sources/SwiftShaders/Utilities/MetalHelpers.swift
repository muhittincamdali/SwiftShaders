import SwiftUI
import Metal
import MetalKit

// MARK: - MetalDevice

/// Shared Metal device utilities for shader operations.
///
/// Provides access to the default Metal device and common utilities
/// for shader development and debugging.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public enum MetalDevice {
    
    /// The default Metal device.
    public static let device: MTLDevice? = MTLCreateSystemDefaultDevice()
    
    /// Whether Metal is supported on this device.
    public static var isSupported: Bool {
        device != nil
    }
    
    /// The device name.
    public static var deviceName: String {
        device?.name ?? "Unknown"
    }
    
    /// Whether the device supports shader barycentric coordinates.
    public static var supportsBarycentricCoordinates: Bool {
        device?.supportsFamily(.apple4) ?? false
    }
    
    /// The maximum threads per threadgroup.
    public static var maxThreadsPerThreadgroup: MTLSize? {
        device?.maxThreadsPerThreadgroup
    }
    
    /// Available feature sets information.
    public static func checkFeatureSupport() -> [String: Bool] {
        guard let device else { return [:] }
        
        return [
            "Apple GPU Family 1": device.supportsFamily(.apple1),
            "Apple GPU Family 2": device.supportsFamily(.apple2),
            "Apple GPU Family 3": device.supportsFamily(.apple3),
            "Apple GPU Family 4": device.supportsFamily(.apple4),
            "Apple GPU Family 5": device.supportsFamily(.apple5),
            "Apple GPU Family 6": device.supportsFamily(.apple6),
            "Apple GPU Family 7": device.supportsFamily(.apple7),
            "Apple GPU Family 8": device.supportsFamily(.apple8),
            "Apple GPU Family 9": device.supportsFamily(.apple9),
        ]
    }
}

// MARK: - ShaderDebug

/// Debugging utilities for shader development.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public enum ShaderDebug {
    
    /// Logs shader library information.
    public static func logShaderInfo() {
        print("=== SwiftShaders Debug Info ===")
        print("Metal Supported: \(MetalDevice.isSupported)")
        print("Device: \(MetalDevice.deviceName)")
        print("Shader Count: \(ShaderLibrary.shared.count)")
        print("")
        
        print("Available Shaders by Category:")
        for category in ShaderLibrary.ShaderCategory.allCases {
            let shaders = ShaderLibrary.shared.shaders(in: category)
            print("  \(category.rawValue.capitalized): \(shaders.count)")
            for shader in shaders {
                print("    - \(shader.name)")
            }
        }
        print("===============================")
    }
    
    /// Creates a debug overlay showing shader parameters.
    public static func debugOverlay(
        time: Double,
        fps: Double = 0
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Time: \(String(format: "%.2f", time))")
            Text("FPS: \(String(format: "%.0f", fps))")
            Text("Device: \(MetalDevice.deviceName)")
        }
        .font(.system(.caption, design: .monospaced))
        .foregroundStyle(.white)
        .padding(8)
        .background(.black.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Color Utilities

/// Color conversion utilities for shader parameters.
public enum ShaderColor {
    
    /// Converts a SwiftUI Color to normalized RGBA values.
    /// - Parameter color: The SwiftUI color.
    /// - Returns: Tuple of (red, green, blue, alpha) values from 0-1.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
    public static func toRGBA(_ color: Color) -> (r: Double, g: Double, b: Double, a: Double) {
        let resolved = color.resolve(in: .init())
        return (
            r: Double(resolved.red),
            g: Double(resolved.green),
            b: Double(resolved.blue),
            a: Double(resolved.opacity)
        )
    }
    
    /// Converts HSL values to RGB.
    /// - Parameters:
    ///   - h: Hue (0-1).
    ///   - s: Saturation (0-1).
    ///   - l: Lightness (0-1).
    /// - Returns: Tuple of (red, green, blue) values from 0-1.
    public static func hslToRGB(h: Double, s: Double, l: Double) -> (r: Double, g: Double, b: Double) {
        if s == 0 {
            return (l, l, l)
        }
        
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        
        func hueToRGB(_ p: Double, _ q: Double, _ t: Double) -> Double {
            var t = t
            if t < 0 { t += 1 }
            if t > 1 { t -= 1 }
            if t < 1/6 { return p + (q - p) * 6 * t }
            if t < 1/2 { return q }
            if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
            return p
        }
        
        return (
            r: hueToRGB(p, q, h + 1/3),
            g: hueToRGB(p, q, h),
            b: hueToRGB(p, q, h - 1/3)
        )
    }
    
    /// Converts RGB to HSL.
    /// - Parameters:
    ///   - r: Red (0-1).
    ///   - g: Green (0-1).
    ///   - b: Blue (0-1).
    /// - Returns: Tuple of (hue, saturation, lightness) values from 0-1.
    public static func rgbToHSL(r: Double, g: Double, b: Double) -> (h: Double, s: Double, l: Double) {
        let maxC = max(r, max(g, b))
        let minC = min(r, min(g, b))
        let delta = maxC - minC
        
        var h: Double = 0
        var s: Double = 0
        let l = (maxC + minC) / 2
        
        if delta != 0 {
            s = l < 0.5 ? delta / (maxC + minC) : delta / (2 - maxC - minC)
            
            if r == maxC {
                h = (g - b) / delta + (g < b ? 6 : 0)
            } else if g == maxC {
                h = (b - r) / delta + 2
            } else {
                h = (r - g) / delta + 4
            }
            h /= 6
        }
        
        return (h, s, l)
    }
}

// MARK: - Math Utilities

/// Math utilities for shader calculations.
public enum ShaderMath {
    
    /// Linear interpolation.
    public static func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + (b - a) * t
    }
    
    /// Smooth step interpolation.
    public static func smoothstep(_ edge0: Double, _ edge1: Double, _ x: Double) -> Double {
        let t = max(0, min(1, (x - edge0) / (edge1 - edge0)))
        return t * t * (3 - 2 * t)
    }
    
    /// Smoother step interpolation.
    public static func smootherstep(_ edge0: Double, _ edge1: Double, _ x: Double) -> Double {
        let t = max(0, min(1, (x - edge0) / (edge1 - edge0)))
        return t * t * t * (t * (t * 6 - 15) + 10)
    }
    
    /// Maps a value from one range to another.
    public static func map(
        _ value: Double,
        from: ClosedRange<Double>,
        to: ClosedRange<Double>
    ) -> Double {
        let normalized = (value - from.lowerBound) / (from.upperBound - from.lowerBound)
        return to.lowerBound + normalized * (to.upperBound - to.lowerBound)
    }
    
    /// Ping-pong (triangle wave) function.
    public static func pingPong(_ t: Double, _ length: Double) -> Double {
        let mod = t.truncatingRemainder(dividingBy: length * 2)
        return length - abs(mod - length)
    }
    
    /// Normalized sine wave (0-1 output).
    public static func normalizedSin(_ t: Double) -> Double {
        (sin(t) + 1) / 2
    }
    
    /// Normalized cosine wave (0-1 output).
    public static func normalizedCos(_ t: Double) -> Double {
        (cos(t) + 1) / 2
    }
}

// MARK: - Performance Monitoring

/// Performance monitoring for shader effects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
@MainActor
public final class ShaderPerformanceMonitor: ObservableObject {
    
    @Published public private(set) var fps: Double = 0
    @Published public private(set) var frameTime: Double = 0
    
    private var lastFrameTime: CFTimeInterval = 0
    private var frameCount: Int = 0
    private var fpsUpdateTime: CFTimeInterval = 0
    
    /// Shared monitor instance.
    public static let shared = ShaderPerformanceMonitor()
    
    private init() {}
    
    /// Updates performance metrics. Call once per frame.
    public func update() {
        let currentTime = CACurrentMediaTime()
        
        if lastFrameTime > 0 {
            frameTime = (currentTime - lastFrameTime) * 1000 // ms
        }
        
        lastFrameTime = currentTime
        frameCount += 1
        
        // Update FPS every second
        if currentTime - fpsUpdateTime >= 1.0 {
            fps = Double(frameCount) / (currentTime - fpsUpdateTime)
            frameCount = 0
            fpsUpdateTime = currentTime
        }
    }
    
    /// Resets all metrics.
    public func reset() {
        fps = 0
        frameTime = 0
        lastFrameTime = 0
        frameCount = 0
        fpsUpdateTime = 0
    }
}
