import SwiftUI

// MARK: - BarrelDistortionModifier

/// Applies barrel (fisheye) distortion effect.
///
/// Creates a bulging distortion similar to fisheye lens.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct BarrelDistortionModifier: ViewModifier {
    
    public var strength: Double
    public var zoom: Double
    
    /// Creates a barrel distortion modifier.
    /// - Parameters:
    ///   - strength: Distortion strength (positive = barrel, negative = pincushion).
    ///   - zoom: Zoom level to compensate for distortion.
    public init(strength: Double = 0.3, zoom: Double = 1.0) {
        self.strength = strength
        self.zoom = zoom
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.barrelDistortion(
                .float(strength),
                .float(zoom)
            ),
            maxSampleOffset: CGSize(width: 100, height: 100)
        )
    }
}

// MARK: - SphereBulgeModifier

/// Creates a spherical bulge at a point.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SphereBulgeModifier: ViewModifier {
    
    public var center: CGPoint
    public var radius: Double
    public var strength: Double
    
    /// Creates a sphere bulge modifier.
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 100.0,
        strength: Double = 0.5
    ) {
        self.center = center
        self.radius = radius
        self.strength = strength
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.sphereBulge(
                .float(center.x),
                .float(center.y),
                .float(radius),
                .float(strength)
            ),
            maxSampleOffset: CGSize(width: radius, height: radius)
        )
    }
}

// MARK: - PinchModifier

/// Creates a pinch/squeeze distortion.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PinchModifier: ViewModifier {
    
    public var center: CGPoint
    public var radius: Double
    public var strength: Double
    
    /// Creates a pinch modifier.
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 100.0,
        strength: Double = 2.0
    ) {
        self.center = center
        self.radius = radius
        self.strength = strength
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.pinchDistortion(
                .float(center.x),
                .float(center.y),
                .float(radius),
                .float(strength)
            ),
            maxSampleOffset: CGSize(width: radius, height: radius)
        )
    }
}

// MARK: - SwirlModifier

/// Creates a swirl/twirl distortion.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SwirlModifier: ViewModifier {
    
    public var center: CGPoint
    public var radius: Double
    public var angle: Double
    
    /// Creates a swirl modifier.
    /// - Parameters:
    ///   - center: Swirl center (normalized 0-1).
    ///   - radius: Effect radius in points.
    ///   - angle: Twist angle in radians.
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 150.0,
        angle: Double = 3.0
    ) {
        self.center = center
        self.radius = radius
        self.angle = angle
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.swirlDistortion(
                .float(center.x),
                .float(center.y),
                .float(radius),
                .float(angle)
            ),
            maxSampleOffset: CGSize(width: radius, height: radius)
        )
    }
}

// MARK: - KaleidoscopeModifier

/// Creates a kaleidoscope mirror effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct KaleidoscopeModifier: ViewModifier {
    
    public var segments: Double
    public var rotation: Double
    
    /// Creates a kaleidoscope modifier.
    /// - Parameters:
    ///   - segments: Number of mirror segments.
    ///   - rotation: Rotation angle in radians.
    public init(segments: Double = 6.0, rotation: Double = 0.0) {
        self.segments = max(2, segments)
        self.rotation = rotation
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.kaleidoscope(
                .float(segments),
                .float(rotation)
            ),
            maxSampleOffset: CGSize(width: 200, height: 200)
        )
    }
}

// MARK: - MagnifyModifier

/// Creates a magnifying glass effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct MagnifyModifier: ViewModifier {
    
    public var center: CGPoint
    public var radius: Double
    public var magnification: Double
    
    /// Creates a magnify modifier.
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 100.0,
        magnification: Double = 2.0
    ) {
        self.center = center
        self.radius = radius
        self.magnification = max(1.0, magnification)
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.magnify(
                .float(center.x),
                .float(center.y),
                .float(radius),
                .float(magnification)
            ),
            maxSampleOffset: CGSize(width: radius, height: radius)
        )
    }
}

// MARK: - LensWarpModifier

/// Camera lens warp distortion.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct LensWarpModifier: ViewModifier {
    
    public var k1: Double
    public var k2: Double
    public var center: CGPoint
    
    /// Creates a lens warp modifier.
    /// - Parameters:
    ///   - k1: Primary distortion coefficient.
    ///   - k2: Secondary distortion coefficient.
    ///   - center: Lens center (normalized).
    public init(
        k1: Double = 0.2,
        k2: Double = 0.0,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) {
        self.k1 = k1
        self.k2 = k2
        self.center = center
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.lensWarp(
                .float(k1),
                .float(k2),
                .float(center.x),
                .float(center.y)
            ),
            maxSampleOffset: CGSize(width: 80, height: 80)
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies barrel distortion.
    func barrelDistortion(strength: Double = 0.3, zoom: Double = 1.0) -> some View {
        modifier(BarrelDistortionModifier(strength: strength, zoom: zoom))
    }
    
    /// Applies sphere bulge.
    func sphereBulge(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 100.0,
        strength: Double = 0.5
    ) -> some View {
        modifier(SphereBulgeModifier(center: center, radius: radius, strength: strength))
    }
    
    /// Applies pinch distortion.
    func pinchDistortion(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 100.0,
        strength: Double = 2.0
    ) -> some View {
        modifier(PinchModifier(center: center, radius: radius, strength: strength))
    }
    
    /// Applies swirl distortion.
    func swirlDistortion(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 150.0,
        angle: Double = 3.0
    ) -> some View {
        modifier(SwirlModifier(center: center, radius: radius, angle: angle))
    }
    
    /// Applies kaleidoscope effect.
    func kaleidoscope(segments: Double = 6.0, rotation: Double = 0.0) -> some View {
        modifier(KaleidoscopeModifier(segments: segments, rotation: rotation))
    }
    
    /// Applies magnifying glass effect.
    func magnify(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 100.0,
        magnification: Double = 2.0
    ) -> some View {
        modifier(MagnifyModifier(center: center, radius: radius, magnification: magnification))
    }
    
    /// Applies lens warp.
    func lensWarp(
        k1: Double = 0.2,
        k2: Double = 0.0,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) -> some View {
        modifier(LensWarpModifier(k1: k1, k2: k2, center: center))
    }
}
