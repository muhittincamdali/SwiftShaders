import SwiftUI

// MARK: - BlurModifier

/// A view modifier that applies blur simulation effects.
///
/// Note: True Gaussian blur requires layerEffect. These modifiers
/// provide visual approximations using color effects.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(BlurModifier(radius: 10.0))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct BlurModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Blur radius.
    public var radius: Double
    
    // MARK: - Initialization
    
    /// Creates a blur modifier.
    /// - Parameter radius: Blur radius (default: 10.0).
    public init(radius: Double = 10.0) {
        self.radius = max(0, radius)
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.boxBlurSimulation(.float(radius))
        )
    }
}

// MARK: - RadialBlurModifier

/// Zoom/radial blur effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RadialBlurModifier: ViewModifier {
    
    public var center: CGPoint
    public var strength: Double
    
    /// Creates a radial blur modifier.
    /// - Parameters:
    ///   - center: Blur center point (normalized 0-1).
    ///   - strength: Blur strength.
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        strength: Double = 0.5
    ) {
        self.center = center
        self.strength = strength
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.radialBlur(
                .float(center.x),
                .float(center.y),
                .float(strength)
            )
        )
    }
}

// MARK: - MotionBlurModifier

/// Directional motion blur effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct MotionBlurModifier: ViewModifier {
    
    public var angle: Double
    public var strength: Double
    
    /// Creates a motion blur modifier.
    /// - Parameters:
    ///   - angle: Motion direction in radians.
    ///   - strength: Blur strength.
    public init(angle: Double = 0.0, strength: Double = 0.5) {
        self.angle = angle
        self.strength = strength
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.motionBlur(
                .float(angle),
                .float(strength)
            )
        )
    }
}

// MARK: - TiltShiftModifier

/// Tilt-shift miniature effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct TiltShiftModifier: ViewModifier {
    
    public var focusY: Double
    public var focusWidth: Double
    public var blurStrength: Double
    
    /// Creates a tilt-shift modifier.
    /// - Parameters:
    ///   - focusY: Vertical focus position (0-1).
    ///   - focusWidth: Width of focus band.
    ///   - blurStrength: Blur strength outside focus.
    public init(
        focusY: Double = 0.5,
        focusWidth: Double = 0.2,
        blurStrength: Double = 1.0
    ) {
        self.focusY = focusY
        self.focusWidth = focusWidth
        self.blurStrength = blurStrength
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.tiltShiftBlur(
                .float(focusY),
                .float(focusWidth),
                .float(blurStrength)
            )
        )
    }
}

// MARK: - DepthOfFieldModifier

/// Simulated depth of field effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DepthOfFieldModifier: ViewModifier {
    
    public var focalDistance: Double
    public var aperture: Double
    public var maxBlur: Double
    
    /// Creates a depth of field modifier.
    /// - Parameters:
    ///   - focalDistance: Focus distance (0-1).
    ///   - aperture: Aperture size (smaller = more blur).
    ///   - maxBlur: Maximum blur amount.
    public init(
        focalDistance: Double = 0.5,
        aperture: Double = 0.1,
        maxBlur: Double = 1.0
    ) {
        self.focalDistance = focalDistance
        self.aperture = aperture
        self.maxBlur = maxBlur
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.depthOfFieldBlur(
                .float(focalDistance),
                .float(aperture),
                .float(maxBlur)
            )
        )
    }
}

// MARK: - FrostModifier

/// Frosted glass effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FrostModifier: ViewModifier {
    
    public var time: Double
    public var frostAmount: Double
    public var grainSize: Double
    
    /// Creates a frost modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - frostAmount: Frost intensity.
    ///   - grainSize: Size of frost grain texture.
    public init(
        time: Double,
        frostAmount: Double = 1.0,
        grainSize: Double = 100.0
    ) {
        self.time = time
        self.frostAmount = frostAmount
        self.grainSize = grainSize
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.frostBlur(
                .float(time),
                .float(frostAmount),
                .float(grainSize)
            )
        )
    }
}

// MARK: - SoftGlowModifier

/// Soft glow/bloom effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SoftGlowModifier: ViewModifier {
    
    public var intensity: Double
    public var threshold: Double
    
    /// Creates a soft glow modifier.
    /// - Parameters:
    ///   - intensity: Glow intensity.
    ///   - threshold: Brightness threshold for glow.
    public init(intensity: Double = 1.0, threshold: Double = 0.5) {
        self.intensity = intensity
        self.threshold = threshold
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.softGlow(
                .float(intensity),
                .float(threshold)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies radial blur effect.
    func radialBlur(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        strength: Double = 0.5
    ) -> some View {
        modifier(RadialBlurModifier(center: center, strength: strength))
    }
    
    /// Applies motion blur effect.
    func motionBlur(angle: Double = 0.0, strength: Double = 0.5) -> some View {
        modifier(MotionBlurModifier(angle: angle, strength: strength))
    }
    
    /// Applies tilt-shift effect.
    func tiltShift(
        focusY: Double = 0.5,
        focusWidth: Double = 0.2,
        blurStrength: Double = 1.0
    ) -> some View {
        modifier(TiltShiftModifier(
            focusY: focusY,
            focusWidth: focusWidth,
            blurStrength: blurStrength
        ))
    }
    
    /// Applies depth of field effect.
    func depthOfField(
        focalDistance: Double = 0.5,
        aperture: Double = 0.1,
        maxBlur: Double = 1.0
    ) -> some View {
        modifier(DepthOfFieldModifier(
            focalDistance: focalDistance,
            aperture: aperture,
            maxBlur: maxBlur
        ))
    }
    
    /// Applies frost effect.
    func frostEffect(
        time: Double,
        amount: Double = 1.0,
        grainSize: Double = 100.0
    ) -> some View {
        modifier(FrostModifier(
            time: time,
            frostAmount: amount,
            grainSize: grainSize
        ))
    }
    
    /// Applies soft glow effect.
    func softGlow(intensity: Double = 1.0, threshold: Double = 0.5) -> some View {
        modifier(SoftGlowModifier(intensity: intensity, threshold: threshold))
    }
}
