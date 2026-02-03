import SwiftUI

// MARK: - ChromaticModifier

/// A view modifier that applies chromatic aberration effect.
///
/// Chromatic aberration simulates the color fringing that occurs in optical
/// systems when different wavelengths of light focus at slightly different points.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(ChromaticModifier(intensity: 0.02, angle: 0.0))
/// ```
///
/// ## Parameters
///
/// - `intensity`: Controls the strength of the color separation (0.0 - 1.0)
/// - `angle`: Direction of the aberration in radians
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ChromaticModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Strength of the chromatic aberration effect.
    public var intensity: Double
    
    /// Direction angle of the color separation.
    public var angle: Double
    
    /// Center point for radial aberration.
    public var center: CGPoint
    
    // MARK: - Initialization
    
    /// Creates a chromatic aberration modifier.
    /// - Parameters:
    ///   - intensity: Aberration strength (default: 0.01).
    ///   - angle: Direction angle in radians (default: 0.0).
    ///   - center: Center point for radial effect (default: center).
    public init(
        intensity: Double = 0.01,
        angle: Double = 0.0,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) {
        self.intensity = intensity
        self.angle = angle
        self.center = center
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.chromaticAberration(
                .float(intensity),
                .float(center.x),
                .float(center.y)
            )
        )
    }
}

// MARK: - DirectionalChromaticModifier

/// Applies directional chromatic aberration along a specific axis.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DirectionalChromaticModifier: ViewModifier {
    
    public var intensity: Double
    public var angle: Double
    
    /// Creates a directional chromatic modifier.
    /// - Parameters:
    ///   - intensity: Aberration strength.
    ///   - angle: Direction angle in radians.
    public init(intensity: Double = 0.02, angle: Double = 0.0) {
        self.intensity = intensity
        self.angle = angle
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.directionalChromatic(
                .float(intensity),
                .float(angle)
            )
        )
    }
}

// MARK: - PulsingChromaticModifier

/// Chromatic aberration with animated pulsing intensity.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PulsingChromaticModifier: ViewModifier {
    
    public var time: Double
    public var baseIntensity: Double
    public var pulseSpeed: Double
    public var pulseAmount: Double
    
    /// Creates a pulsing chromatic modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - baseIntensity: Base aberration strength.
    ///   - pulseSpeed: Pulse animation speed.
    ///   - pulseAmount: Pulse intensity variation.
    public init(
        time: Double,
        baseIntensity: Double = 0.01,
        pulseSpeed: Double = 2.0,
        pulseAmount: Double = 0.02
    ) {
        self.time = time
        self.baseIntensity = baseIntensity
        self.pulseSpeed = pulseSpeed
        self.pulseAmount = pulseAmount
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.pulsingChromatic(
                .float(time),
                .float(baseIntensity),
                .float(pulseSpeed),
                .float(pulseAmount)
            )
        )
    }
}

// MARK: - RGBSplitModifier

/// Creates an RGB channel split effect for glitch aesthetics.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RGBSplitModifier: ViewModifier {
    
    public var splitX: Double
    public var splitY: Double
    
    /// Creates an RGB split modifier.
    /// - Parameters:
    ///   - splitX: Horizontal split amount.
    ///   - splitY: Vertical split amount.
    public init(splitX: Double = 0.1, splitY: Double = 0.1) {
        self.splitX = splitX
        self.splitY = splitY
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.rgbSplit(
                .float(splitX),
                .float(splitY)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies directional chromatic aberration.
    /// - Parameters:
    ///   - intensity: Aberration strength.
    ///   - angle: Direction angle.
    /// - Returns: A view with directional chromatic aberration.
    func directionalChromatic(
        intensity: Double = 0.02,
        angle: Double = 0.0
    ) -> some View {
        modifier(DirectionalChromaticModifier(intensity: intensity, angle: angle))
    }
    
    /// Applies pulsing chromatic aberration.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - baseIntensity: Base strength.
    ///   - pulseSpeed: Pulse speed.
    ///   - pulseAmount: Pulse variation.
    /// - Returns: A view with pulsing chromatic aberration.
    func pulsingChromatic(
        time: Double,
        baseIntensity: Double = 0.01,
        pulseSpeed: Double = 2.0,
        pulseAmount: Double = 0.02
    ) -> some View {
        modifier(PulsingChromaticModifier(
            time: time,
            baseIntensity: baseIntensity,
            pulseSpeed: pulseSpeed,
            pulseAmount: pulseAmount
        ))
    }
    
    /// Applies RGB channel split effect.
    /// - Parameters:
    ///   - splitX: Horizontal split.
    ///   - splitY: Vertical split.
    /// - Returns: A view with RGB split effect.
    func rgbSplit(
        splitX: Double = 0.1,
        splitY: Double = 0.1
    ) -> some View {
        modifier(RGBSplitModifier(splitX: splitX, splitY: splitY))
    }
}
